//
//  SweaterTextView.swift
//  Sweater
//
//  Created by Liana Haque on 12/28/20.
//


import UIKit

class SweaterTextView: UITextView {

    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init( fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        let edgeInset: CGFloat = 10
        layer.cornerRadius = 10
        
        textColor                                   = .label
        tintColor                                   = .label
        textAlignment                               = .left
        textContainerInset                          = UIEdgeInsets(top: 10, left: edgeInset, bottom: edgeInset, right: edgeInset)
        font                                        = UIFont.preferredFont(forTextStyle: .headline)
        font                                        = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 2))
        backgroundColor                             = .clear
                        
      //  backgroundColor                             = .tertiarySystemBackground
        autocorrectionType                          = .no
        returnKeyType                               = .done
                    
        allowsEditingTextAttributes                 = false
        isEditable                                  = false
        isScrollEnabled                             = false
    }
}
