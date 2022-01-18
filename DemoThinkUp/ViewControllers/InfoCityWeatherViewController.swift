//
//  InfoCityWeatherViewController.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/3/21.
//

import UIKit

class InfoCityWeatherViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var cloudValueLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    
    // Public vars
    var viewModel: InfoCityWeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Private Functions
private extension InfoCityWeatherViewController {
    func setupUI() {
        cityNameLabel.text = viewModel?.cityName
        tempValueLabel.text = viewModel?.temperature
        humidityValueLabel.text = viewModel?.humidity
        cloudValueLabel.text = viewModel?.cloudiness
        windValueLabel.text = viewModel?.wind
    }
}

 
