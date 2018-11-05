//
//  User.swift
//  candy
//
//  Created by Erik Perez on 8/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

enum UserError: Error {
    case instantiationFailed([String: Any])
}

class User: NSObject {
    let id: Int
    let firstName: String
    let lastName: String
    let age: String
    let phoneNumber: String
    let gender: Int
    let seeking: Int
    var token: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var dictionary: NSDictionary {
        return ["id": self.id,
                "first_name": self.firstName,
                "last_name": self.lastName,
                "age": self.age,
                "phone_number": self.phoneNumber,
                "gender": self.gender,
                "seeking": self.seeking,
                "token": "**Token saved in keychain**"
        ] as NSDictionary
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
            let token = json["token"] as? String,
            let profileImageJSON = json["profile_images"] as? [[String: Any]]
            else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.seeking = seeking
        self.token = token
        
        let profileImages = profileImageJSON.compactMap(ProfileImage.init)
        print("User -> Init: profile images: \(profileImages.last!.description)")
        guard let recentImage = profileImages.last else { return }
        UserDefaults.standard.set(recentImage.imageURL, forKey: "profile-image-aws-url")
        // TODO: Cache user first name and display in settings
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
