//
//  SweatSecondaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

class SweatWeatherDescriptionCell: UICollectionViewCell, FetchWeatherDescriptionListener {
    func onDataReceived(weatherDescription: WeatherDescription) {
        // set labels here.
    }
    
    static let reuseID = "SecondaryCell"

    let generalDescriptionLabel = SweatSecondaryLabel()
    let descriptionLabel = SweatSecondaryLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(generalDescriptionLabel)
        contentView.addSubview(descriptionLabel)
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = CGColor.init(red: 255, green: 250, blue: 250, alpha: 1)
        generalDescriptionLabel.backgroundColor = .blue
        descriptionLabel.backgroundColor = .yellow
       // mainDescriptorLabel.text = "SCREAMING BLUE"

        NSLayoutConstraint.activate([
            generalDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            generalDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            generalDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            generalDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: generalDescriptionLabel.bottomAnchor, constant: 10)
        ])
    }
}
