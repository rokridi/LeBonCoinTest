//
//  WeatherItem.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation
import CoreData

protocol Storable {
    associatedtype DataBaseEntity: NSManagedObject, DataBaseModelable
}

protocol WeatherItemModelable {
    var temperature: Double {get}
    var humidity: Double {get}
    var cape: Double {get}
}

struct WeatherItem: WeatherItemModelable, Storable {
    
    typealias DataBaseEntity = CDWeatherItem
    
    let temperature: Double
    let humidity: Double
    let cape: Double
}

extension WeatherItem {
    init(date: Date, dictionary: [String: Any]) {
        
        if let tempDict = dictionary["temperature"] as? [String: Double], let temp = tempDict["2m"] {
            temperature = temp
        } else {
            temperature = 0
        }
        
        if let humidityDict = dictionary["humidite"] as? [String: Double], let humid = humidityDict["2m"] {
            humidity = humid
        } else {
            humidity = 0
        }
        
        cape = dictionary["humidite"] as? Double ?? 0
    }
}
