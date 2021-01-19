//
//  SweatDawnDuskCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/13/21.
//

import UIKit

class SweatDawnDuskCell: UICollectionViewCell, ConfigurableCell {
    static let reuseID          = "SweatDawnDuskCell"
    let stackView               = UIStackView()
    let dawnLabel               = SweatMainLabel(textAlignment: .center, fontSize: 20)
    let duskLabel               = SweatMainLabel(textAlignment: .center, fontSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: DawnDusk) {
        dawnLabel.text = String(data.dawn)
        duskLabel.text = String(data.dusk)
    }
    
    private func configure() {
        stackView.addSubview(dawnLabel)
        stackView.addSubview(duskLabel)
        contentView.addSubview(stackView)
        
//        view.accessibilityIdentifier = "HOURLY WEATHER VIEW"
        contentView.accessibilityIdentifier = "Hello  i am SweatDawnDuskCell"
//        dawnLabel.text = "I AM DAWN"
//        duskLabel.text = "I AM DUSK"
//        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis                                      = .horizontal
        stackView.distribution                              = .fill
        stackView.spacing                                   = 40.0
        stackView.backgroundColor                           = .red
        
        translatesAutoresizingMaskIntoConstraints           = false
        //layer.backgroundColor                               = CGColor.init(red: 255, green: 250, blue: 250, alpha: 1.0)
        
        dawnLabel.backgroundColor                           = .systemPurple
        duskLabel.backgroundColor                           = .systemBlue
        
        backgroundColor = .systemYellow
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           // stackView.heightAnchor.constraint(equalToConstant: 100)
            //stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            //stackView.heightAnchor.constraint(equalToConstant: 100)
           // stackView.leadingAnchor.constraint(equalTo: mainTemperatureLabel.trailingAnchor, constant: 10),
//            stackView.widthAnchor.constraint(equalToConstant: 400),
//            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
