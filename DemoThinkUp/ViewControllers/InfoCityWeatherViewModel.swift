//
//  InfoCityWeatherViewModel.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

final class InfoCityWeatherViewModel {
    // Private Vars
    private var _city: City?
    
    // MARK: - Init
    init(city: City?) {
        _city = city
    }
    
    // MARK: - Public Vars
    var cityName: String {
        return _city?.title ?? ""
    }
    
    var temperature: String {
        return "\(_city?.weather?.temperature ?? 0)"
    }
    
    var humidity: String {
        return "\(_city?.weather?.humidity ?? 0)"
    }
    
    var cloudiness: String {
        return "\(_city?.weather?.cloudiness ?? 0)"
    }
    
    var wind: String {
        return "\(_city?.weather?.windSpeed ?? 0)"
    }
}
