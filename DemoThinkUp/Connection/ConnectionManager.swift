//
//  ConnectionManager.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import Alamofire
import SwiftyJSON
import Reachability

class ConnectionManager: NSObject {
    
    var keyOpenWeatherApi = "aedb5d2945545fb3d33688ba546d32d1"
    var keyGoogleApi = "AIzaSyCnTp_9Ei1DvvVwqlz0Od8QvRN-unk6aBo"
    
    let dataResponseSerializer = DataResponseSerializer(emptyResponseCodes: [200, 204, 205])
    
    /* SINGLETON */
    static let sharedInstance: ConnectionManager = {
        let instance = ConnectionManager()
        
        return instance
    }()
    
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            case .none:
                return false
            }
        }
        catch {
            return false
        }
    }
}
