//
//  UIAlertController+RIBs.swift
//  candy
//
//  Created by Erik Perez on 8/10/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import RIBs

extension UIAlertController: ViewControllable {
    public var uiviewController: UIViewController { return self }
    
    public convenience init(title: String, description: String?, preferredStyle: UIAlertControllerStyle) {
        self.init(title: title, message: description, preferredStyle: preferredStyle)
    }
}
