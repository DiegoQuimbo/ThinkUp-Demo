//
//  City.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import MapKit
import SwiftyJSON
import CoreData

class City: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let weather: Weather?
    
    init(jsonOBject: JSON) {
        title = jsonOBject["name"].string ?? ""
        let coordDict = jsonOBject["coord"].dictionary
        if let lon = coordDict?["lon"]?.double, let lat = coordDict?["lat"]?.double {
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    
        weather = Weather(jsonObject: jsonOBject)
    }
    
    init(managedObject: NSManagedObject) {
        title = managedObject.value(forKey: "title") as? String
        let long = managedObject.value(forKey: "longitude") as? Double ?? 0.0
        let lat = managedObject.value(forKey: "latitude") as? Double ?? 0.0
        coordinate =  CLLocationCoordinate2D(latitude: lat, longitude: long)
        weather = Weather(managedObject: managedObject)
    }
}
