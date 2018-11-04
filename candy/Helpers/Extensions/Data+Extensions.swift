//
//  Data+Extensions.swift
//  candy
//
//  Created by Erik Perez on 10/31/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

extension Data {
    // Used for adding to body of upload profile image request
    // Huge thanks to NewFiveFour on GitHub
    // LINK: https://github.com/newfivefour/BlogPosts/blob/master/swift-form-data-multipart-upload-URLRequest.md
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
