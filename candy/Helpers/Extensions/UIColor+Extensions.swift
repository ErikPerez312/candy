//
//  UIColor+Extensions.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        let base: CGFloat = 255.0
        self.init(red: CGFloat(red) / base,
                  green: CGFloat(green) / base,
                  blue: CGFloat(blue) / base,
                  alpha: 1.0)
    }
    
    // MARK: Colors
    
    static var candyBackgroundPink: UIColor {
        return UIColor(red: 255, green: 238, blue: 238)
    }
    static var candyBackgroundBlue: UIColor {
        return UIColor(red: 36, green: 59, blue: 107)
    }
    
    // MARK: UI Component Colors
    
    static var candyNavigationBarBackground: UIColor {
        return UIColor(red: 255, green: 230, blue: 230)
    }
    static var candyNavigationBarShadow: UIColor {
        return UIColor(red: 249, green: 205, blue: 205)
    }
    static var candyActivityCardBackground: UIColor {
        return UIColor(red: 255, green: 255, blue: 255)
    }
    static var candyProgressBarPink: UIColor {
        return UIColor(red: 235, green: 176, blue: 176)
    }
}
