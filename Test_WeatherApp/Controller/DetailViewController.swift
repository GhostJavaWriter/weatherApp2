//
//  DetailViewController.swift
//  Test_WeatherApp
//
//  Created by Bair Nadtsalov on 14.02.2021.
//

import UIKit

class DetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescrLabel: UILabel!
    @IBOutlet weak var weatherIconLabel: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var city : CityObject?
    fileprivate var forecastsWeather : [DayModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    fileprivate func setupView() {
        guard let currentCity = city else { return }
        
        cityNameLabel.text = currentCity.name
        weatherDescrLabel.text = currentCity.condition
        
        if let temp = currentCity.temp {
            temperatureLabel.text = "\(temp)°"
        } else {
            temperatureLabel.text = "--"
        }
        
        forecastsWeather = currentCity.forecasts
        
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
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forecastsWeather?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Day", for: indexPath)
        
        if let forecastsWeather = forecastsWeather {
            cell.textLabel?.text = forecastsWeather[indexPath.row].date
            cell.detailTextLabel?.text = "\(forecastsWeather[indexPath.row].temp)"
        } else {
            print("forecast object is nil")
        }
        
        return cell
    }
    
}
