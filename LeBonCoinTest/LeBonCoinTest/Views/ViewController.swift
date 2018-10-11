//
//  ViewController.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeatherViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherItemTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherItemTableViewCell")
        
        if let dataController = CoreDataController(name: "LeBonCoinTest") {
            dataController.loadStore(completionHandler: { [weak self] error in
                
                guard error == nil, let config = WeatherHTTPClientConfiguration.configuration(from: "configuration") else {
                    return
                }
                let databaseClient = WeatherCoreDataBaseClient(coreDataControler: dataController)
                let httpClient = WeatherHTTPClient(baseURL: config.baseURL, authKey: config.authKey, cKey: config.cKey)
                self?.viewModel = WeatherViewModel(httpClient: httpClient, database: databaseClient)
                self?.bindViewModel()
                self?.viewModel?.fetchWeather()
            })
        }
    }
}

//MARK: - ViewModeBinding
extension ViewController {
    private func bindViewModel() {
        viewModel?.error = { error in
            print(error)
        }
        
        viewModel?.dataLoaded = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherItemTableViewCell") as! WeatherItemTableViewCell
        cell.viewModel = viewModel?.viewModel(at: indexPath)
        return cell
    }
}

//MARK : - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: Grab a viewModel representing the detail and inject it in the net viewcontroller.
    }
}

