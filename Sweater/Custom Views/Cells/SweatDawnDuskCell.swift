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
    let dawnLabel               = SweatMainLabel(textAlignment: .center, fontSize: 18)
    let duskLabel               = SweatMainLabel(textAlignment: .center, fontSize: 18)
    
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

        dawnLabel.text = "Sunrise at : " + dawnTimeString
        duskLabel.text = "Sunset at : " + duskTimeString
    }
    
    private func configure() {
        stackView.addArrangedSubview(dawnLabel)
        stackView.addArrangedSubview(duskLabel)
        contentView.addSubview(stackView)
              
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis                                      = .horizontal
        stackView.distribution                              = .fill
        stackView.spacing                                   = 40.0        
        translatesAutoresizingMaskIntoConstraints           = false
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: 0)
        ])
    }
}
