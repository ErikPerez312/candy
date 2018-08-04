//
//  CandyComponents.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

struct CandyComponents {
    static func navigationBarTitleLabel(withTitle title: String) -> UILabel {
        let font = UIFont(name: "Avenir-Black", size: 14)!
        let titleLabel = UILabel()
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: UIColor.candyBackgroundBlue,
            NSAttributedStringKey.kern: 4.0,
            ]
        
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        titleLabel.sizeToFit()
        return titleLabel
    }
    
    static func underlinedAvenirAttributedString(withTitle title: String) -> NSAttributedString {
        let font = UIFont(name: "Avenir-Heavy", size: 14)!
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: UIColor.candyBackgroundBlue,
            NSAttributedStringKey.underlineColor: UIColor.candyBackgroundBlue,
            NSAttributedStringKey.underlineStyle: 1,
            ]
        
        let title = NSAttributedString(string: title, attributes: attributes)
        return title
    }
    
    static func avenirAttributedString(title: String, fontSize size: CGFloat = 14.0) -> NSAttributedString {
        let font = UIFont(name: "Avenir-Black", size: size)!
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: UIColor.candyBackgroundBlue,
            NSAttributedStringKey.kern: 1.0,
            ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
