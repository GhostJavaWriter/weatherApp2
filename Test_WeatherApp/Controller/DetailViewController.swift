//
//  DetailViewController.swift
//  Test_WeatherApp
//
//  Created by Bair Nadtsalov on 14.02.2021.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescrLabel: UILabel!
    @IBOutlet weak var weatherIconLabel: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var city : CityObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    fileprivate func setupView() {
        guard let currentCity = city else { return }
        
        cityNameLabel.text = currentCity.name
        weatherDescrLabel.text = currentCity.condition
        
        if let temp = currentCity.temp {
            temperatureLabel.text = "\(temp)"
        } else {
            temperatureLabel.text = "--"
        }
        
        if let urlString = currentCity.icon {
            let url = "https://yastatic.net/weather/i/icons/blueye/color/svg/\(urlString).svg"
            if let imageURL = URL(string: url) {
                
                NetworkManager.shared.getIcon(iconURL: imageURL) { [weak self] (image) in
                    DispatchQueue.main.async {
                        self?.weatherIconLabel.image = image
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
