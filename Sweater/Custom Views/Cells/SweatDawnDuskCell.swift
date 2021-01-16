//
//  SweatDawnDuskCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/13/21.
//

import UIKit

class SweatDawnDuskCell: UICollectionViewCell {
    static let reuseID          = "SweatDawnDuskCell"
    let stackView               = UIStackView()
    let dawnLabel               = SweatMainLabel()
    let duskLabel               = SweatMainLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        stackView.addSubview(dawnLabel)
        stackView.addSubview(duskLabel)
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis                                      = .horizontal
        stackView.distribution                              = .equalSpacing
        stackView.spacing                                   = 20.0
        stackView.backgroundColor                           = .blue
        
        translatesAutoresizingMaskIntoConstraints           = false
        layer.backgroundColor                               = CGColor.init(red: 255, green: 250, blue: 250, alpha: 1.0)
        
        dawnLabel.backgroundColor                           = .purple
        duskLabel.backgroundColor                           = .systemYellow
        
        backgroundColor = .systemGreen
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
           // stackView.leadingAnchor.constraint(equalTo: mainTemperatureLabel.trailingAnchor, constant: 10),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
