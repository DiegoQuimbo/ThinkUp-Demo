//
//  Utilities.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import Foundation
import CoreData
import UIKit

class Utilities {
    enum DefaultSettings: String{
        case didSignUp
    }
    
    static let cityEntitie = "CityPoint"
    
    class func isValidEmail(_ email: String?) -> Bool {
        guard let emailValue = email else {
            return false
        }
        let trimmedEmail = emailValue.trimmingCharacters(in: .whitespaces)
        if trimmedEmail.count > 50 || trimmedEmail.count == 0 {
            return false
        }
    
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: trimmedEmail)
    }
    
    class func saveUserDidSignUp() {
        UserDefaults.standard.set(true, forKey: DefaultSettings.didSignUp.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    class func userDidSignUp() -> Bool {
        return UserDefaults.standard.bool(forKey: DefaultSettings.didSignUp.rawValue)
    }
}

// MARK: - Core Data Functions
extension Utilities {
    class func getCitiesSaved() -> [City] {
        var cities: [City] = []
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return cities
          }
          
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: cityEntitie)
          
          do {
            let citiesSaved = try managedContext.fetch(fetchRequest)
            for cityObj in citiesSaved {
                let city = City(managedObject: cityObj)
                cities.append(city)
            }
            return cities
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return cities
          }
    }
    
    class func saveCitiesInCoreData(cities: [City]) {
        clearDatabase()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: cityEntitie, in: managedContext)!
        
        for city in cities {
            let cityPoint = NSManagedObject(entity: entity, insertInto: managedContext)
            cityPoint.setValue(city.title, forKeyPath: "title")
            cityPoint.setValue(city.coordinate.longitude, forKeyPath: "longitude")
            cityPoint.setValue(city.coordinate.latitude, forKeyPath: "latitude")
            
            cityPoint.setValue(city.weather?.temperature, forKeyPath: "temperature")
            cityPoint.setValue(city.weather?.humidity, forKeyPath: "humidity")
            cityPoint.setValue(city.weather?.cloudiness, forKeyPath: "cloudiness")
            cityPoint.setValue(city.weather?.windSpeed, forKeyPath: "windSpeed")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func clearDatabase() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: cityEntitie)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch {
            print("Detele all data in error :", error)
        }
    }
}
