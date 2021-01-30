//
//  SweatPrimaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

class SweatTemperatureCell: UICollectionViewCell, ConfigurableCell {
    func configure(data: Temperature) {
        mainTemperatureLabel.text = String(data.main) + "°"
        minTemperatureLabel.text = String(data.min) + "°"
        maxtemperatureLabel.text = String(data.max) + "°"
    }
    
    static let reuseID          = "PrimaryCell"
    let stackView               = UIStackView()
    let mainTemperatureLabel    = SweatMainLabel(textAlignment: .center, fontSize: 45)
    let minTemperatureLabel     = SweatSecondaryLabel(textAlignment: .center, fontSize: 20)
    let maxtemperatureLabel     = SweatSecondaryLabel(textAlignment: .center, fontSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(mainTemperatureLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(minTemperatureLabel)
        stackView.addArrangedSubview(maxtemperatureLabel)
//        backgroundColor = .orange
//        mainTemperatureLabel.backgroundColor = .red
//        minTemperatureLabel.backgroundColor = .blue
//        maxtemperatureLabel.backgroundColor = .purple
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis                                      = .vertical
        stackView.distribution                              = .fillProportionally
        stackView.spacing                                   = 20.0
        
        translatesAutoresizingMaskIntoConstraints           = false

        NSLayoutConstraint.activate([
            mainTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            mainTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainTemperatureLabel.widthAnchor.constraint(equalToConstant: 160),
            mainTemperatureLabel.heightAnchor.constraint(equalToConstant: 160),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: mainTemperatureLabel.trailingAnchor, constant: 10),
            stackView.widthAnchor.constraint(equalToConstant: 100),
            stackView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
}
