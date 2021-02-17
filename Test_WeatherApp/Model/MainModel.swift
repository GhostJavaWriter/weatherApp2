//
//  MainModel.swift
//  Test_WeatherApp
//
//  Created by Bair Nadtsalov on 09.02.2021.
//

import Foundation

class MainModel: Codable {
    
    var fact : WeatherModel?
    var forecasts : [ForecastsModel]?
}
