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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let dawnTime = Date(timeIntervalSince1970: TimeInterval(data.dawn))
        let duskTime = Date(timeIntervalSince1970: TimeInterval(data.dusk))
        
        let dawnTimeString = dateFormatter.string(from: dawnTime)
        let duskTimeString = dateFormatter.string(from: duskTime)

        dawnLabel.text = dawnTimeString
        duskLabel.text = duskTimeString
    }
    
    private func configure() {
        stackView.addSubview(dawnLabel)
        stackView.addSubview(duskLabel)
        contentView.addSubview(stackView)
              
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis                                      = .horizontal
        stackView.distribution                              = .fill
        stackView.spacing                                   = 40.0
        stackView.backgroundColor                           = .red
        
        translatesAutoresizingMaskIntoConstraints           = false
        dawnLabel.backgroundColor                           = .systemPurple
        duskLabel.backgroundColor                           = .systemBlue
        
        backgroundColor = .systemYellow
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
}
