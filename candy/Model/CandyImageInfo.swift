//
//  CandyImageInfo.swift
//  candy
//
//  Created by Erik Perez on 10/31/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit

final class CandyImageInfo {
    let boundary = UUID().uuidString
    let filename: String
    let imageData: Data
    
    init(filename: String, imageData: Data) {
        self.filename = filename
        self.imageData = imageData
    }
}
