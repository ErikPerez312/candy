//
//  User.swift
//  candy
//
//  Created by Erik Perez on 8/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

class User: NSObject {
    
    // MARK: - Properties
    
    var id: Int
    var firstName: String
    var lastName: String
    var age: String
    var phoneNumber: String
    var gender: Int
    var seeking: Int
    var token: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: - Methods
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let age = json["age"] as? String,
            let phoneNumber = json["phone_number"] as? String,
            let gender = json["gender"] as? Int,
            let seeking = json["seeking"] as? Int,
            let token = json["token"] as? String
            else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.seeking = seeking
        self.token = token
    }
}

// MARK: - Extension
extension User{
    override var description: String {
        return "ID: \(String(describing: self.id))\nFirst: \(self.firstName)\nLast: \(self.lastName)\nPhoneNumber: \(self.phoneNumber)\nAge: \(self.age)\nGender: \(self.gender)\nSeeking: \(self.seeking)\nToken: \(String(describing: self.token))"
    }
    
    static func convertGenderToInt(_ gender: String) -> Int {
        switch gender {
        case "Male": return 0
        case "Female": return 1
        case "Men": return 1
        case "Women": return 2
        default:
            // Returning 3 for "Both"
            return 3
        }
    }
}



