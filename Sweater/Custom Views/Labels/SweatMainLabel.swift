//
//  SweatMainLabel.swift
//  Sweater
//
//  Created by Liana Haque on 12/8/20.
//

import UIKit

class SweatMainLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        layer.cornerRadius                          = 10
        textColor                                   = .white
        numberOfLines                               = 0
        font                                        = UIFont.preferredFont(forTextStyle: .headline)
        adjustsFontForContentSizeCategory           = true
        adjustsFontSizeToFitWidth                   = true
        minimumScaleFactor                          = 0.75
        layer.cornerRadius                          = 10
        lineBreakMode                               = .byWordWrapping
    }
}
