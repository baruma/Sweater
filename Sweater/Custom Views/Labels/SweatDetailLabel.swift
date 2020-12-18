//
//  SweatDetailLabel.swift
//  Sweater
//
//  Created by Liana Haque on 12/15/20.
//

import UIKit

class SweatDetailLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        textColor                                   = .white
        numberOfLines                               = 0
        font                                        = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory           = true
        adjustsFontSizeToFitWidth                   = true
        minimumScaleFactor                          = 0.75
        lineBreakMode                               = .byWordWrapping
    }
}
