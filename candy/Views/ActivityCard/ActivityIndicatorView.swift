//
//  ActivityIndicatorView.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    var backgroundCircleLayer: CAShapeLayer!
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Init not implemented")
    }
    
    /// Start the activity indicator
    func startIndicator() {
        animateCircle()
    }
    
    /// End the activity indicator
    func endIndicator() {
        layer.removeAllAnimations()
    }
    
    private func setUpBackgroundCircleLayer() {
        backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        backgroundCircleLayer.lineCap = kCALineCapRound
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = UIColor.candyBackgroundPink.cgColor
        backgroundCircleLayer.lineWidth = 4.0
        layer.addSublayer(backgroundCircleLayer)
    }
    
    private func setUpCircleLayer() {
        circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.lineCap = kCALineCapRound
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.candyBackgroundBlue.cgColor
        circleLayer.lineWidth = 4.0
        circleLayer.strokeEnd = 0.95
        layer.addSublayer(circleLayer)
    }
    
    override func draw(_ rect: CGRect) {
        setUpBackgroundCircleLayer()
        setUpCircleLayer()
    }
    
    func animateCircle() {
        // We want to animate the rotation property of the layer
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        // .keyPath = #kayPath(cashapelayer.strokeend)
        
        // Set the animation duration appropriately
        animation.duration = 1.0
        animation.repeatCount = .infinity
        
        // Animate from 0 (beginning) to 6.28 (full circle)
        animation.fromValue = 0.0
        animation.toValue = CGFloat(Double.pi * 2)
        
        // Do a ease out animation (i.e The speed of the animation slows down towards end)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        layer.add(animation, forKey: nil)
    }
}
