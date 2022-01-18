//
//  URLs.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import Foundation

struct URLs {
    static var baseOpenWeatherURL : URL = URL(string: "https://api.openweathermap.org/data/2.5/")!
    static var baseGoogleApiURL : URL = URL(string: "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?")!
    
    struct City {
        static func getCityWeather(name: String) -> String {
            return "\(baseOpenWeatherURL)weather?q=\(name)&appid=\(ConnectionManager.sharedInstance.keyOpenWeatherApi)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        static func getCitiesWith(name: String) -> String {
            return "\(baseGoogleApiURL)input=\(name)&inputtype=textquery&fields=name&key=\(ConnectionManager.sharedInstance.keyGoogleApi)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
    }
}
