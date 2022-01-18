//
//  ConnectionManager_City.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import Alamofire
import SwiftyJSON

class ConnectionManager_City: ConnectionManager {
    
    class func getCityWeather(name: String, completion :@escaping (_ city: City?) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .accept("application/json")
        ]
        
        AF.request(URLs.City.getCityWeather(name: name), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let city = City(jsonOBject: JSON(data))
                    completion(city)
                case .failure( _):
                    completion(nil)
                }
            }
    }
    
    class func getCitiesNames(input: String, completion :@escaping (_ cityNames: [String]) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .accept("application/json")
        ]
        
        AF.request(URLs.City.getCitiesWith(name: input), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    var cityNames: [String] = []
                    let json = JSON(data)
                    let candidates = json["candidates"].array ?? []
                    for cityName in candidates {
                        if let name = cityName["name"].string {
                            cityNames.append(name)
                        }
                    }
                    completion(cityNames)
                case .failure( _):
                    completion([])
                }
            }
    }
}
