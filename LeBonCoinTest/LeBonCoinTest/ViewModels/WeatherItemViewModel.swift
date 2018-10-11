//
//  WeatherItemViewModel.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation

protocol WeatherItemViewModelable {
    var temperature: String {get}
    var humidity: String {get}
}

class WeatherItemViewModel: WeatherItemViewModelable {
    let temperature: String
    let humidity: String
    
    init(model: WeatherItemModelable) {
        temperature = "\(model.temperature) Kelvin"
        humidity = "\(model.humidity) %"
    }
}

