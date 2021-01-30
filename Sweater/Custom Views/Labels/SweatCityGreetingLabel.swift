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
        numberOfLines                               = 0
        font                                        = UIFont.preferredFont(forTextStyle: .subheadline)
        adjustsFontForContentSizeCategory           = true
        adjustsFontSizeToFitWidth                   = true
        minimumScaleFactor                          = 0.75
        lineBreakMode                               = .byTruncatingTail
    }
}
