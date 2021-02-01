//
//  CityGreetingCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/29/21.
//

import UIKit

class CityGreetingCell: UICollectionViewCell {
    static let reuseID = "CityGreetingCell"
    
    let cityLabel = SweatCityGreetingLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(cityLabel)
        cityLabel.textAlignment = .left
        cityLabel.text = "San Diego"
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

}
