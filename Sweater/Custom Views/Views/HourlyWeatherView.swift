//
//  HourlyWeatherDetailView.swift
//  Sweater
//
//  Created by Liana Haque on 1/4/21.
//

import UIKit

class HourlyWeatherView: UIView {

    let temperatureLabel = SweatDetailLabel()
    let timeLabel = SweatDetailLabel()
    let weatherImage = UIImageView()
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
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(timeLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis                                      = .vertical
        stackView.distribution                              = .fillEqually
        stackView.spacing                                   = 10.0
      //  stackView.backgroundColor = .yellow
        
        translatesAutoresizingMaskIntoConstraints   = false
     //   temperatureLabel.backgroundColor            = .brown
     //   timeLabel.backgroundColor                   = .black
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 110),
            stackView.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
}
