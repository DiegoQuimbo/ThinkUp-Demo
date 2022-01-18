//
//  LocationServiceViewModel.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

import CoreLocation

protocol LocationViewModelProtocol {}
final class LocationServiceViewModel: LocationViewModelProtocol {}

extension LocationViewModelProtocol {
    
    func locationServicesIsAuthorized() -> Bool {
        return LocationService.sharedInstance.isLocationServicesAuthorized()
    }
    
    func getLocationStatus() -> CLAuthorizationStatus {
        return LocationService.sharedInstance.status
    }
    
    func getUserCurrentCityName(currentCity: ((String?) -> Void)?) {
        LocationService.sharedInstance.userLocation = { cityName in
            currentCity?(cityName)
            LocationService.sharedInstance.stopMonitoringLocalzationAuthChanges()
        }
    }
    
    func requestLocationAuthorization(localizationStatusAuth:((Bool) -> Void)?) {
        LocationService.sharedInstance.requestLocationAuthorization(changeStatus: { status in
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                localizationStatusAuth?(true)
            case .restricted, .denied:
                localizationStatusAuth?(false)
            default: break
            }
        })
    }
}
