//
//  MapWeatherViewModel.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import PromiseKit
import MapKit
import CoreData

final class MapWeatherViewModel: NSObject {
    // Location Protocol
    var locationViewModel: LocationViewModelProtocol = LocationServiceViewModel()
    
    // Private properties
    private var _defaultCities: [City] = []
    private var _citySelected: City?
    
    // MARK: - Public Functions
    func getMapCitiesPoints() -> [City] {
       return _defaultCities
    }
    
    func saveCitySelected(city: City) {
        _citySelected = city
    }
    
    func getInfoCityViewModel() -> InfoCityWeatherViewModel? {
        return InfoCityWeatherViewModel(city: _citySelected)
    }
    
    func hasConnectivity() -> Bool {
        return ConnectionManager.sharedInstance.hasConnectivity()
    }
    
    // MARK: - Core Data
    func loadStatusOfCitiesFromCoreData() {
        self._defaultCities = Utilities.getCitiesSaved()
    }
    
    // MARK: - Call Network
    func getStatusOfCitiesFromAPI(completion :@escaping () -> ()) {
        firstly {
            // First get city name of user current position
            getCurrentUserCityName()
        }.then { currentCity in
            // Get info of defaults cities and current user city
            when(fulfilled: self.getCityStatus(cityName: currentCity),
                 self.getCityStatus(cityName: "Montevideo"),
                 self.getCityStatus(cityName: "Florianópolis"),
                 self.getCityStatus(cityName: "Asunción"),
                 self.getCityStatus(cityName: "Rosario"))
        }.done { [unowned self] currentCity, montevideoCity, florianopolis, asuncion, rosario in
            // Clean nil cities
            self._defaultCities = [currentCity, montevideoCity, florianopolis, asuncion, rosario].compactMap { return $0 }
            // Save status of cities in Core Data in order to show them whitout internet connection
            Utilities.saveCitiesInCoreData(cities: self._defaultCities)
            completion()
        }.catch { error in
            print("Error: ", error.localizedDescription)
            completion()
        }
    }
    
    func getStatusOfCitySearched(name: String, completion: @escaping (City?) -> ()) {
        ConnectionManager_City.getCityWeather(name: name) { cityStatus in
           completion(cityStatus)
        }
    }
    
    // MARK: - private Functions
    private func getCurrentUserCityName() -> Promise<String> {
        return Promise { currentCity in
            startGettingCurrentUserCity { cityName in
                currentCity.fulfill(cityName ?? "")
            }
        }
    }
    
    private func getCityStatus(cityName: String) -> Promise<City?> {
        return Promise { city in
            ConnectionManager_City.getCityWeather(name: cityName) { cityStatus in
                city.fulfill(cityStatus)
            }
        }
    }
}

// MARK: - Location Functions
private extension MapWeatherViewModel {
    func startGettingCurrentUserCity(completion :@escaping (String?) -> ()) {
        // Verify if the user has given location permissions
        if locationViewModel.locationServicesIsAuthorized() {
            getUserCurrentCityName(completion: completion)
        } else {
            checkStatusLocationPermissions(completion: completion)
        }
    }
    
    func getUserCurrentCityName(completion :@escaping (String?) -> ()) {
        locationViewModel.getUserCurrentCityName(currentCity:{ city in
            completion(city)
        })
    }

    func checkStatusLocationPermissions(completion :@escaping (String?) -> ()) {
        switch locationViewModel.getLocationStatus() {
        case .denied:
            // The permissions was denied so return nil of current user city
            completion(nil)
        case .notDetermined:
            // Show the alert asking for the location permissions in case that the user didn't determinate them yet
            locationViewModel.requestLocationAuthorization(localizationStatusAuth: { [unowned self] authorized in
                if !authorized {
                    // The permissions was denied so return nil of current user city
                    completion(nil)
                } else {
                    // Get the location permissions and try to get the location
                    self.getUserCurrentCityName(completion: completion)
                }
            })
        default:
            break
        }
    }
}

