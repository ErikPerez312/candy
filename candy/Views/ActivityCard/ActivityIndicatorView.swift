//
//  ActivityIndicatorView.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

final class ActivityIndicatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not supported")
    }
    
    override func draw(_ rect: CGRect) {
        buildAnimationCircleLayers()
    }
    
    func startAnimation() {
        animateCircle()
    }
    
    func endAnimation() {
        layer.removeAllAnimations()
    }
    
    // MARK: - Private
    
    private func buildAnimationCircleLayers() {
        let layerMaker: (UIColor) -> CAShapeLayer = { color in
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(ovalIn: self.bounds).cgPath
            layer.lineCap = kCALineCapRound
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = color.cgColor
            layer.lineWidth = 4.0
            return layer
        }
        let backgroundCircle = layerMaker(.candyBackgroundPink)
        layer.addSublayer(backgroundCircle)
        
        let topCircle = layerMaker(.candyBackgroundBlue)
        topCircle.strokeEnd = 0.95
        layer.addSublayer(topCircle)
    }
    
    private func animateCircle() {
        // We want to animate the rotation property of the layer
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
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
