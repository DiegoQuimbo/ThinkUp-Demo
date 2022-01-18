//
//  LocationService.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

import CoreLocation

class LocationService: NSObject {
    // Public Vars
    var userLocation: ((String?) -> Void)? {
        didSet {
            if CLLocationManager.locationServicesEnabled() {
                // Start to getting the coordinates
                _localityName = nil
                _isGettingPlacemark = false
                _manager.startUpdatingLocation()
            }
        }
    }
    
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    // Private Vars
    private let _manager: CLLocationManager
    private var _authorizationDidChangeStatus: ((CLAuthorizationStatus) -> Void)?
    private var _localityName: String?
    private var _isGettingPlacemark = false
    
    // MARK: -  Initializers
    static let sharedInstance: LocationService = {
        return LocationService()
    }()

    init(manager: CLLocationManager = .init()) {
        self._manager = manager
        super.init()
        self._manager.delegate = self
    }
    
    // MARK: -  Public Methods
    func requestLocationAuthorization(changeStatus: ((CLAuthorizationStatus) -> Void)?) {
        _manager.desiredAccuracy = kCLLocationAccuracyBest
        _manager.requestWhenInUseAuthorization()
        _authorizationDidChangeStatus = changeStatus
    }
    
    func isLocationServicesAuthorized() -> Bool {
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    func locationServicesIsNoDetermined() -> Bool {
        return status == .notDetermined
    }
    
    func stopMonitoringLocalzationAuthChanges() {
        _authorizationDidChangeStatus = nil
    }
    
    // MARK: -  Private Methods
    deinit {
        _manager.stopUpdatingLocation()
    }
}

// MARK: -  Location services
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        userLocation?(nil )
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (_localityName != nil) {
            return
        }
        if let location = locations.last {
            manager.stopUpdatingLocation()
            if !_isGettingPlacemark {
                _isGettingPlacemark = true
                initReverseGeocodeLocation(userLocation: location)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        _authorizationDidChangeStatus?(status)
    }
    
    func initReverseGeocodeLocation(userLocation: CLLocation) {
        if _localityName != nil {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { [unowned self] (placemarks, error) in
            if let placemark =  placemarks?.last {
                self._localityName = placemark.locality
                self.userLocation?(placemark.locality)
            } else {
                self.userLocation?(nil)
            }
        }
    }
}
