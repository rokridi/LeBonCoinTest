//
//  WeatherItemTableViewCell.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import UIKit

class WeatherItemTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    var viewModel: WeatherItemViewModelable? {
        didSet {
            temperatureLabel?.text = viewModel?.temperature
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
