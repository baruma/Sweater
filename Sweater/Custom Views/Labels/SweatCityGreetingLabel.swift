//
//  SweatCityGreetingLabel.swift
//  Sweater
//
//  Created by Liana Haque on 1/29/21.
//

import UIKit

class SweatCityGreetingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        textColor                                   = .white
        numberOfLines                               = 1
       // font                                        = UIFont.preferredFont(forTextStyle: .largeTitle)
        font                                        = .systemFont(ofSize: 40, weight: .heavy)
        adjustsFontForContentSizeCategory           = true
        adjustsFontSizeToFitWidth                   = true
        minimumScaleFactor                          = 0.75
        lineBreakMode                               = .byTruncatingTail
    }
}
