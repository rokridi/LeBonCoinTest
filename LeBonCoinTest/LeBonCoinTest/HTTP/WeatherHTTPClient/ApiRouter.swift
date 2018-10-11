//
//  ApiRouter.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    case weather(latitude: Double, longitude: Double, authKey: String, cKey: String, baseURL: String)
    
    private var baseURL: String {
        switch self {
        case let .weather(latitude: _, longitude: _, authKey: _, cKey: _, baseURL: baseURL):
            return baseURL
        }
    }
    
    private var path: String {
        switch self {
        case .weather:
            return "gfs/json"
        }
    }
    
    private var method: HTTPMethod {
        return .get
    }
    
    private var parameters: [String: AnyObject] {
        switch self {
        case let .weather(latitude: latitude, longitude: longitude, authKey: authKey, cKey: cKey, baseURL: _):
            return ["_ll": "\(latitude),\(longitude)" as AnyObject,
                    "_auth": authKey as AnyObject,
                    "_c": cKey as AnyObject]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try self.baseURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!.asURL()

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        
        let urlRequest = try URLEncoding.default.encode(request, with: parameters)
        
        let urlString = urlRequest.url?.absoluteString.removingPercentEncoding
        
        if let string = urlString, let url = URL(string: string) {
            return URLRequest(url: url)
        }
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
