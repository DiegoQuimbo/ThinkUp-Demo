//
//  MapWeatherViewController.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import UIKit
import MapKit
import MBProgressHUD

protocol HandleMapSearch {
    func gotValidateCity(name: String)
}

class MapWeatherViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController: UISearchController? = nil
    
    // Private Properties
    private let _viewModel = MapWeatherViewModel()
    private enum MapSegue: String {
        case ShowCityInfo
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if _viewModel.hasConnectivity() {
            // Get status of cities form API
            getCitiesWeatherStatusFromAPI()
        } else {
            // Get latest status of cities saved in Core Data
            getCitiesWeatherStatusFromCoreData()
        }
    }
    
    // MARK: - Private methods
    func setupUI() {
        insertSearchBar()
    }
    
    private func insertSearchBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationSearchTable = storyboard.instantiateViewController(withIdentifier: "LocationSearchTableView") as! LocationSearchTableView
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchBar.delegate = locationSearchTable
        
        resultSearchController!.searchBar.sizeToFit()
        resultSearchController!.searchBar.placeholder = "Search for places".localizedUsingMainFile()
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    private func getCitiesWeatherStatusFromAPI() {
        showProgressHud(view: self.view)
        _viewModel.getStatusOfCitiesFromAPI { [unowned self] in
            self.hideProgressHud(view: self.view)
            self.loadCitiesInMap()
        }
    }
    
    private func getCitiesWeatherStatusFromCoreData() {
        _viewModel.loadStatusOfCitiesFromCoreData()
        self.loadCitiesInMap()
    }
    
    private func loadCitiesInMap() {
        mapView.addAnnotations(_viewModel.getMapCitiesPoints() )
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MapSegue.ShowCityInfo.rawValue {
            let infoCityWController = segue.destination as! InfoCityWeatherViewController
            infoCityWController.viewModel = _viewModel.getInfoCityViewModel()
        }
    }
}

// MARK: - MKMapViewDelegate methods
extension MapWeatherViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let citySelected = view.annotation as? City {
            _viewModel.saveCitySelected(city: citySelected)
            performSegue(withIdentifier: MapSegue.ShowCityInfo.rawValue, sender: nil)
        }
    }
}

// MARK: - HandleMapSearch delegate
extension MapWeatherViewController: HandleMapSearch {
    func gotValidateCity(name: String) {
        showProgressHud(view: self.view)
        _viewModel.getStatusOfCitySearched(name: name) { [unowned self] (city) in
            self.hideProgressHud(view: self.view)
            if let citySearched = city {
                self.resultSearchController!.searchBar.text = ""
                self.mapView.addAnnotation(citySearched)
                self.mapView.centerToLocation(citySearched)
            }
        }
    }
}

