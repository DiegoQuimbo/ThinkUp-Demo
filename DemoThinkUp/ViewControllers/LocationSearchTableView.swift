//
//  LocationSearchTableView.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class LocationSearchTableView: UIViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Public properties
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    // Private properties
    private let _viewModel = LocationSearchViewModel()
    private var _cityNames = BehaviorRelay<[String]>(value: [])
    private let _disposeBag = DisposeBag()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRxTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear List
        _cityNames.accept([])
    }
    
    // MARK: - Private methods
    private func setUpRxTableView() {
        _cityNames.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, cityName, cell) in
                cell.textLabel?.text = cityName
        }.disposed(by: _disposeBag)
        
        tableView.rx.modelSelected(String.self)
        .subscribe(onNext: { [unowned self] cityName in
            self.handleMapSearchDelegate?.gotValidateCity(name: cityName)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: _disposeBag)
    }
}

extension LocationSearchTableView: UISearchBarDelegate {    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        showProgressHud(view: self.view)
        _viewModel.searchCities(input: text) {
            self.hideProgressHud(view: self.view)
            self._cityNames.accept(self._viewModel.getCityNamesSearched())
        }
    }
}
