//
//  SweatSecondaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

class SweatWeatherDescriptionCell: UICollectionViewCell, ConfigurableCell {

    var mainDescriptions  = [String]()
    var detailedDescriptions = [String]()
    
    func configure(data: WeatherDescriptionAggregate) {
        generalDescriptionTextView.text = data.descriptions.map{$0.main!}.joined(separator: " ")
        detailDescriptionTextView.text = data.descriptions.map{$0.detailed!}.joined(separator: " ")
    }
    
    static let reuseID = "SecondaryCell"
    let generalDescriptionTextView = SweaterTextView(fontSize: 15)
    let detailDescriptionTextView = SweaterTextView(fontSize: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(generalDescriptionTextView)
        contentView.addSubview(detailDescriptionTextView)
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = CGColor.init(red: 255, green: 250, blue: 250, alpha: 1)
        generalDescriptionTextView.backgroundColor = .red
        detailDescriptionTextView.backgroundColor = .red

        NSLayoutConstraint.activate([
            generalDescriptionTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            generalDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            generalDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            generalDescriptionTextView.heightAnchor.constraint(equalToConstant: 40),
            
            detailDescriptionTextView.topAnchor.constraint(equalTo: generalDescriptionTextView.bottomAnchor, constant: 10),
            detailDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailDescriptionTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
