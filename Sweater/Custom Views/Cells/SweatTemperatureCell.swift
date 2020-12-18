//
//  SweatPrimaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

// this is the person calling.

class SweatTemperatureCell: UICollectionViewCell, FetchTemperatureListener {
    func onDataReceived(temp: Temperature) {
        mainTemperatureLabel.text = String(temp.main)
        minTemperatureLabel.text = String(temp.min)
        maxtemperatureLabel.text = String(temp.max)
    }
    
    static let reuseID          = "PrimaryCell"
    let stackView               = UIStackView()
    let mainTemperatureLabel    = SweatMainLabel()
    let minTemperatureLabel     = SweatSecondaryLabel()
    let maxtemperatureLabel     = SweatSecondaryLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {

    }
    
    private func configure() {
        contentView.addSubview(mainTemperatureLabel)
        contentView.addSubview(stackView)

        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = CGColor.init(red: 255, green: 250, blue: 250, alpha: 0.5)
        mainTemperatureLabel.backgroundColor = .red
        mainTemperatureLabel.text = "SCREAMING RED"
        
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.axis                                       = NSLayoutConstraint.Axis.vertical
        stackView.distribution                               = UIStackView.Distribution.equalSpacing
        stackView.alignment                                  = UIStackView.Alignment.center
        stackView.spacing                                    = 8.0
//            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxtemperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(minTemperatureLabel)
        stackView.addArrangedSubview(maxtemperatureLabel)
        
        mainTemperatureLabel.text = "102"
        minTemperatureLabel.text = "20"
        maxtemperatureLabel.text = "100"

        NSLayoutConstraint.activate([
            mainTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainTemperatureLabel.widthAnchor.constraint(equalToConstant: 80),
            mainTemperatureLabel.heightAnchor.constraint(equalToConstant: 80),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: mainTemperatureLabel.leadingAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalToConstant: 80),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
