//
//  TertiaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

#warning("Rename the main Temperature Label.")

class SweatWeatherDetailInformationCell: UICollectionViewCell, ConfigurableCell {
    
    /// The weather data displays in order of :
    /// 1. FeelsLike
    /// 2. Precipitation
    /// 3. Humidity
    /// You will need to insert the labels as a stack view with each corresponding numreric value to display weather to viewer.
  
    static let reuseID = "TertiaryCell"
    let mainTemperatureLabel = SweatMainLabel(textAlignment: .center, fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: String) {
        mainTemperatureLabel.text = data
    }
    
    private func configure() {
        contentView.addSubview(mainTemperatureLabel)
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = CGColor.init(red: 255, green: 250, blue: 250, alpha: 1)
        mainTemperatureLabel.backgroundColor = .blue
        mainTemperatureLabel.text = "SCREAMING BLUE"

        NSLayoutConstraint.activate([
            mainTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainTemperatureLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
