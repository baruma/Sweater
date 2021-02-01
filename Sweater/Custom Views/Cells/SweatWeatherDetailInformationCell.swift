//
//  TertiaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

class SweatWeatherDetailInformationCell: UICollectionViewCell, ConfigurableCell {
    /// The weather data displays in order of :
    /// 1. FeelsLike
    /// 2. Precipitation
    /// 3. Humidity
    /// You will need to insert the labels as a stack view with each corresponding numreric value to display weather to viewer.
  
    static let reuseID = "TertiaryCell"
    let detailInfoLabel = SweatMainLabel(textAlignment: .center, fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: String) {
        detailInfoLabel.text = data
    }
    
    private func configure() {
        contentView.addSubview(detailInfoLabel)
        translatesAutoresizingMaskIntoConstraints   = false
        detailInfoLabel.text                        = ""

        NSLayoutConstraint.activate([
            detailInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            detailInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailInfoLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
