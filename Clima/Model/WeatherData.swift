//
//  WeatherData.swift
//  Clima
//
//  Created by Siva Hitesh Kasturi.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
    
}

struct Weather : Codable {
    let id : Int
}

struct Main : Codable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max : Double
    let pressure : Int
    let humidity : Int
}
