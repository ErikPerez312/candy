//
//  ActivityCard.swift
//  candy
//
//  Created by Erik Perez on 8/6/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit

// TODO: Refactor

class ActivityCard: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        layer.masksToBounds = false
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.candyNavigationBarShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = CGFloat(38)
        layer.shadowOpacity = 1.0
        
        backgroundColor = .candyActivityCardBackground
    }
    
}
