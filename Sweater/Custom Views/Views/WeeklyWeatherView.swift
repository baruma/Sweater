//
//  WeeklyWeatherView.swift
//  Sweater
//
//  Created by Liana Haque on 1/5/21.
//

import UIKit

class WeeklyWeatherView: UIView {
    let maxTemperatureLabel = SweatDetailLabel()
    let minTemperatureLabel = SweatDetailLabel()
    let weatherImage = UIImageView()
    let dayLabel = SweatDetailLabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(stackView)
        stackView.addArrangedSubview(maxTemperatureLabel)
        stackView.addArrangedSubview(weatherImage)
        stackView.addArrangedSubview(minTemperatureLabel)
        stackView.addArrangedSubview(dayLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
    //    stackView.backgroundColor = .yellow
        
        translatesAutoresizingMaskIntoConstraints   = false
//        maxTemperatureLabel.backgroundColor         = .red
//        dayLabel.backgroundColor                    = .blue
//        minTemperatureLabel.backgroundColor         = .systemPink
//        weatherImage.backgroundColor                = .gray
//        maxTemperatureLabel.text                       = "140°"
//        minTemperatureLabel.text                       = "-10°"
//        dayLabel.text                                  = "Wednesday"
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 160),
            stackView.widthAnchor.constraint(equalToConstant: 70),
        ])
    }

}
