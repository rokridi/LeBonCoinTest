//
//  WeatherHTTPClient.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation
import Alamofire

typealias WeatherCompletion = ((Result<WeatherModelable>)->Void)

protocol HTTPClient {
    func weather(latitude: Double, longitude: Double, completion: @escaping WeatherCompletion) -> URLSessionTask?
}

enum WeatherHTTPClientError: Error {
    case jsonError(Error)
    case networkError(Error)
    case apiError(code: Int, message: String)
}

class WeatherHTTPClient {
    
    private let baseURL: String
    private let authKey: String
    private let cKey: String
    private let sessionManager: SessionManager
    
    public init(baseURL: String,
                authKey: String,
                cKey: String,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.baseURL = baseURL
        self.authKey = authKey
        self.cKey = cKey
        sessionManager = SessionManager(configuration: configuration)
    }
}

//MARK: - HTTPClient
extension WeatherHTTPClient: HTTPClient {
    
    @discardableResult
    func weather(latitude: Double,
                 longitude: Double,
                 completion: @escaping WeatherCompletion) -> URLSessionTask? {
        let request = ApiRouter.weather(latitude: latitude, longitude: longitude, authKey: authKey, cKey: cKey, baseURL: baseURL)
        let dataRequest = sessionManager.request(request)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData(completionHandler: { response in
                
                switch response.result {
                case .success(let data):
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        
                        if let dictionary = dictionary {
                            let weather = Weather(dictionary: dictionary)
                            
                            if weather.requestState == 200 {
                                completion(.success(weather))
                            } else {
                                let error = WeatherHTTPClientError.apiError(code: weather.requestState, message: weather.message)
                                completion(.failure(error))
                            }
                        }
                    } catch (let error) {
                        let jsonError = WeatherHTTPClientError.jsonError(error)
                        completion(.failure(jsonError))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        
        return dataRequest.task
    }
}
