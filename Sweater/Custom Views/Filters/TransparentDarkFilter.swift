//
//  TransparentDarkGradientFilter.swift
//  Sweater
//
//  Created by Liana Haque on 2/3/21.
//

import UIKit

class TransparentDarkFilter: UIView {
    
    // Principal Initializer.  You need this if you're going to make an override init, because the override init needs something to override in the first place.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)  // According to rules, you must call super.init before performing any additional init actions.
    }

    // This init will get the override almost always since it overrides the public init anyways.  This is why your view wasn't appearing at all earlier.
    public override init(frame: CGRect) {
        super.init(frame: frame) // According to rules, you must call super.init before performing any additional init actions.
        configure()
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints       = false
        clipsToBounds                                   = true
        backgroundColor                                 = UIColor.black.withAlphaComponent(0.40)
    }
}
