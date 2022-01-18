//
//  Weather.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import SwiftyJSON
import CoreData

struct Weather {
    let temperature: Double
    let humidity: Double
    let cloudiness: Int
    let windSpeed: Double
    
    init(jsonObject: JSON) {
        let mainDict = jsonObject["main"]
        temperature = mainDict["temp"].double ?? 0
        humidity = mainDict["humidity"].double ?? 0
        
        let cloudsDict = jsonObject["clouds"]
        cloudiness = cloudsDict["all"].int ?? 0
        
        let windDict = jsonObject["wind"]
        windSpeed = windDict["speed"].double ?? 0
    }
    
    init(managedObject: NSManagedObject) {
        temperature = managedObject.value(forKey: "temperature") as? Double ?? 0.0
        humidity = managedObject.value(forKey: "humidity") as? Double ?? 0.0
        cloudiness = managedObject.value(forKey: "cloudiness") as? Int ?? 0
        windSpeed = managedObject.value(forKey: "windSpeed") as? Double ?? 0.0
    }
}
