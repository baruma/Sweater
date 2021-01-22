//
//  DarkTransparentGradientView.swift
//  Sweater
//
//  Created by Liana Haque on 1/22/21.
//

import UIKit

//class DarkTransparentGradientView: UIView {
//    let gradient = CAGradientLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure() {
//        self.addSubview(gradient)
//        self.backgroundColor    = .clear
//        self.clipsToBounds      = true
//
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
//
//        view.layer.insertSublayer(gradient, at: 0)
//    }
//}


class DarkTransparentGradientView: UIView {
    
     let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = CGFloat(0.5)
        return layer
    }()
    
    override func draw(_ rect: CGRect) {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = self.startPoint
        gradientLayer.endPoint = self.endPoint
        gradientLayer.colors = self.colors
        gradientLayer.type = self.type
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public var colors: [CGColor] = [UIColor.blue.cgColor, UIColor.yellow.cgColor, UIColor.purple.cgColor] {
        didSet{
            self.gradientLayer.colors = self.colors
        }
    }
    
    public var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            self.gradientLayer.startPoint = startPoint
        }
    }
    
    public var endPoint: CGPoint = CGPoint(x: 1, y: 0) {
        didSet{
            self.gradientLayer.endPoint = self.endPoint
        }
    }
    
    public var type: CAGradientLayerType = .axial {
        didSet {
            gradientLayer.type = self.type
        }
    }
    
}
