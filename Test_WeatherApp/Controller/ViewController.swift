//
//  ViewController.swift
//  Test_WeatherApp
//
//  Created by Bair Nadtsalov on 09.02.2021.
//

/*
 Стартовый экран – таблица со списком из 10 городов (обязательно показать температуру, название города и текущие погодные условия). При желании можно сделать этот список редактируемым. Над таблицей есть SearchBar, в нем пользователь может искать интересующие его города. При нажатии на ячейку пользователь попадает на экран подробной информации,

 Экран подробной информации – после ввода города в SearchBar, приложение должно отобразить экран на котором будет подробная информация о выбранном городе. Дизайн и какую информацию необходимо отображать – решайте вы сами.
 */

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var cities = [CityObject]()
    fileprivate var filteredCities = [CityObject]()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchBarIsEmpty : Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    fileprivate var isFiltering : Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.global().async {
            NetworkManager.shared.getCities(fileName: "citiesList", result: { [weak self] (model) in
                if let cities = model {
                    self?.cities = cities
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                    for city in cities {
                        if let lat = city.lat,
                           let lon = city.lon {
                            NetworkManager.shared.getWeather(lat: lat, lon: lon) { [weak city] (model) in
                                city?.condition = model?.fact?.condition
                                city?.icon = model?.fact?.icon
                                city?.temp = model?.fact?.temp
                            }
                        }
                    }
                }
            })
        }
    }
    
//MARK: - Setup UI
    fileprivate func setupNavigationBar() {
        
        self.navigationItem.title = "Weather"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter..."
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
//MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return print("empty text")}
        filterContentForSearchText(text)
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String) {
        
        filteredCities = cities.filter({ (city: CityObject) -> Bool in
            return city.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredCities.count
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentCity: CityObject
        
        if isFiltering {
            currentCity = filteredCities[indexPath.row]
        } else {
            currentCity = cities[indexPath.row]
        }
        
        cell.textLabel?.text = currentCity.name
        
        if let lat = currentCity.lat,
           let lon = currentCity.lon {
            
            DispatchQueue.global().async {
                NetworkManager.shared.getWeather(lat: lat, lon: lon, result: { [weak cell] (model) in
                    if let temp = model?.fact?.temp,
                       let condition = model?.fact?.condition {
                        DispatchQueue.main.async {
                            cell?.detailTextLabel?.text = "\(temp)°C \(condition)"
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell?.detailTextLabel?.text = "--°C"
                        }
                    }
                })
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCity: CityObject
        
        if isFiltering {
            currentCity = filteredCities[indexPath.row]
        } else {
            currentCity = cities[indexPath.row]
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.city = currentCity
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

