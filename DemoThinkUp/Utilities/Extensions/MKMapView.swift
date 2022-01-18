//
//  MKMapView.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/4/21.
//

import MapKit

extension MKMapView {
  func centerToLocation(_ city: City, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(center: city.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
