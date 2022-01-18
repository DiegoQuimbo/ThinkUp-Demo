//
//  LocationSearchViewModel.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

final class LocationSearchViewModel {
    // Private properties
    private var _citiesNames: [String] = []
    
    // Public properties
    var citiesNamesCount: Int {
        return _citiesNames.count
    }
    
    // MARK: - Public Functions
    func getCityNamesSearched() -> [String] {
        return _citiesNames
    }
    
    func getCityNameBy(index: Int) -> String {
        return _citiesNames[index]
    }
    
    func searchCities(input: String, completion :@escaping () -> ()) {
        // Call Google Places API in order to validate cities names
        ConnectionManager_City.getCitiesNames(input: input) { [unowned self] cityNames in
            self._citiesNames = cityNames
            completion()
        }
    }
}
