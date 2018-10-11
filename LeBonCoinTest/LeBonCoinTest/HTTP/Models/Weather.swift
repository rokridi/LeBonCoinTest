//
//  Weather.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation

protocol WeatherModelable {
    var requestState: Int {get}
    var message: String {get}
    var items: [WeatherItemModelable] {get}
}

struct Weather: WeatherModelable {
    let requestState: Int
    let message: String
    let items: [WeatherItemModelable]
    
    init(dictionary: [String: Any]) {
        
        requestState = dictionary["request_state"] as? Int ?? 0
        message = dictionary["message"] as? String ?? "Empty message"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        items = dictionary.map { (key, value) -> WeatherItemModelable? in
            if let date = dateFormatter.date(from: key), let dict = value as? [String: Any] {
                return WeatherItem(date: date, dictionary: dict)
                
            }
            return nil
            }.compactMap { $0 }
    }
}
