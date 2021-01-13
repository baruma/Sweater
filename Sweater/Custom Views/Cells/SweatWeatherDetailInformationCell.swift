//
//  TertiaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

class SweatWeatherDetailInformationCell: UICollectionViewCell {
    func onDataReceived(weatherDetail: String) {
        mainTemperatureLabel.text = weatherDetail
    }
    
    static let reuseID = "TertiaryCell"
    #warning("Rename the main Temperature Label.")
    let mainTemperatureLabel = SweatMainLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
