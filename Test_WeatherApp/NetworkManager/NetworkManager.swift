//
//  NetworkManager.swift
//  Test_WeatherApp
//
//  Created by Bair Nadtsalov on 09.02.2021.
//

import Foundation
import UIKit

class NetworkManager {
    private init() {}
    
    static let shared : NetworkManager = NetworkManager()
    
    func getIcon(iconURL: URL, complition: @escaping ((UIImage) -> ())) {
        
        URLSession.shared.dataTask(with: iconURL) { (data, response, error) in
            
            guard let data = data, error == nil else { return }
            
            if let image = UIImage(data: data) {
                complition(image)
            } else {
                print("create image error")
            }
        }.resume()
    }
    
    func getWeather(lat: Double, lon: Double, result: @escaping ((MainModel?) -> ())) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.weather.yandex.ru"
        urlComponents.path = "/v2/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "lat", value: "\(lat)"),
                                    URLQueryItem(name: "lon", value: "\(lon)"),
                                    URLQueryItem(name: "lang", value: "ru_RU")]
        
        guard let url = urlComponents.url else { return print("url error")}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("9e96ce0e-4bd7-4ee5-8299-4d1ddf46e3de", forHTTPHeaderField: "X-Yandex-API-Key")
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                let decoder = JSONDecoder()
                var decoderMainModel : MainModel?
                
                if let data = data {
                    decoderMainModel = try? decoder.decode(MainModel.self, from: data)
                    
                } else {
                    print("invalid data")
                }
                result(decoderMainModel)
            } else {
                print(error?.localizedDescription ?? "unknown request error")
            }
        }.resume()
    }
    
    func getCities(fileName name: String, result: @escaping (([CityObject]?) -> ())) {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode([CityObject].self, from: jsonData)
                result(decodedData)
            } else {
                print("json error")
            }
        } catch {
            print("list of cities load fail")
        }
    }
}
