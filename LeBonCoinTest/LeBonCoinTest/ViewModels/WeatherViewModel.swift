//
//  WeatherViewModel.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation

protocol WeatherViewModelable {
    var isLoading: ((Bool)->Void)? {get set}
    var error: ((String)->Void)? {get set}
    var dataLoaded: (()->Void)? {get set}
    func numberOfItems() -> Int
    func fetchWeather()
    func viewModel(at indexPath: IndexPath) -> WeatherItemViewModelable
}

class WeatherViewModel: WeatherViewModelable {
    
    private let httpClient: HTTPClient
    private let database: DataBaseStorage
    
    var isLoading: ((Bool)->Void)?
    var error: ((String)->Void)?
    var dataLoaded: (()->Void)?
    
    private var viewModels = [WeatherItemViewModelable]()
    
    private var task: URLSessionTask?
    
    init(httpClient: HTTPClient, database: DataBaseStorage) {
        self.httpClient = httpClient
        self.database = database
    }
    
    func numberOfItems() -> Int {
        return viewModels.count
    }
    
    func fetchWeather() {
        task?.cancel()
        task = httpClient.weather(latitude: 48.85341, longitude: 2.3488) { [weak self] httpResult in
            switch httpResult {
            case .success(let weatherItems):
                self?.database.deleteAll(WeatherItem.self, completion: { [weak self] _ in
                    self?.database.save(weatherItems as! Array<WeatherItem>, completion: { databaseResult in
                        switch databaseResult {
                        case .success(let items):
                            self?.viewModels = items.map({ WeatherItemViewModel(model: $0) })
                            DispatchQueue.main.async {
                                self?.dataLoaded?()
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self?.error?(error.localizedDescription)
                            }
                        }
                    })
                })
            case .failure(let error):
                self?.database.fetchAll(WeatherItem.self, completion: { result in
                    switch result {
                    case .success(let items):
                        self?.viewModels = items.map({ WeatherItemViewModel(model: $0) })
                        DispatchQueue.main.async {
                            self?.dataLoaded?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.error?(error.localizedDescription)
                        }
                    }
                })
            }
        }
    }
    
    func viewModel(at indexPath: IndexPath) -> WeatherItemViewModelable {
        return viewModels[indexPath.item]
    }
}
