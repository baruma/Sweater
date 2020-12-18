//
//  SweatTransparentView.swift
//  Sweater
//
//  Created by Liana Haque on 12/9/20.
//

import UIKit

class SweatTransparentView: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        layer.cornerRadius                          = 30
        layer.backgroundColor                       = CGColor.init(red: 255, green: 250, blue: 250, alpha: 0.5)
    }
}
