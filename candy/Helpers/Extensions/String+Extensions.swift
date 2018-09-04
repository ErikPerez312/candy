//
//  String+Extensions.swift
//  candy
//
//  Created by Erik Perez on 8/9/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
}
