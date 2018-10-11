//
//  WeatherHTTPClientConfiguration.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation

protocol WeatherHTTPClientConfigurationModelable {
    var baseURL: String {get}
    var authKey: String {get}
    var cKey: String {get}
}

struct WeatherHTTPClientConfiguration: Decodable, WeatherHTTPClientConfigurationModelable {
    
    private enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case authKey = "auth_key"
        case cKey = "c_key"
    }
    
    let baseURL: String
    let authKey: String
    let cKey: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baseURL = try values.decode(String.self, forKey: .baseURL)
        authKey = try values.decode(String.self, forKey: .authKey)
        cKey = try values.decode(String.self, forKey: .cKey)
    }
    
    static func configuration(from file: String) -> WeatherHTTPClientConfiguration? {
        
        guard let file = Bundle.main.url(forResource: file, withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: file)
            return try JSONDecoder().decode(WeatherHTTPClientConfiguration.self, from: data)
        } catch {
            return nil
        }
    }
}
