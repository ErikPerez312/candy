//
//  KeychainHelper.swift
//  candy
//
//  Created by Erik Perez on 8/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import KeychainSwift

/// Type of token that will be stored in Keychain. Raw value is used as Key.
enum KeychainProperty: String {
    case authToken
    case twilioToken
    case userID
}

class KeychainHelper {
    
    static func save(value: String, as property: KeychainProperty) {
        shared.set(value, forKey: property.rawValue, withAccess: .accessibleAlwaysThisDeviceOnly)
    }
    
    static func fetch(_ property: KeychainProperty) -> String?{
        return shared.get(property.rawValue)
    }
    
    static func remove(_ property: KeychainProperty) {
        shared.delete(property.rawValue)
    }
    
    // MARK: - Private
    
    private static let shared = KeychainSwift()
}
