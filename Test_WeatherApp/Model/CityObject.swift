//
//  CityObject.swift
//  Test_WeatherApp
//
//  Created by Bair Nadtsalov on 10.02.2021.
//

import Foundation

class CityObject : Codable {
    
    var name : String?
    var lat : Double?
    var lon : Double?
    var temp : Int?
    var condition : String?
    var icon : String?
    var forecasts : [ForecastsModel]?
}
