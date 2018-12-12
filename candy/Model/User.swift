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

final class User: NSObject {
    let id: Int
    let firstName: String
    let lastName: String
    let phoneNumber: String
    var token: String
    
    var profileImages: [ProfileImage]?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: - Methods
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let phoneNumber = json["phone_number"] as? String,
            let token = json["token"] as? String,
            let profileImageJSON = json["profile_images"] as? [[String: Any]]
            else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.token = token
        self.profileImages = profileImageJSON.compactMap(ProfileImage.init)
    }
    
    func cache() {
        KeychainHelper.save(value: token, as: .authToken)
        KeychainHelper.save(value: "\(id)", as: .userID)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(firstName, forKey: "userFirstName")
        guard let recentImage = profileImages?.last else { return }
        UserDefaults.standard.set(recentImage.imageURL, forKey: "profile-image-aws-url")
    }
    
    static func clearCache() {
        KeychainHelper.remove(.authToken)
        KeychainHelper.remove(.userID)
        UserDefaults.standard.removeObject(forKey: "userFirstName")
        UserDefaults.standard.removeObject(forKey: "profile-image-aws-url")
        UserDefaults.standard.removeObject(forKey: "profile-image")
    }
    
    static func convertGenderIntToString(_ int: Int) -> String {
        return int == 0 ? "MALE" : "FEMALE"
    }
    
}

// MARK: - Extension
extension User{
    override var description: String {
        return "ID: \(String(describing: self.id))\nFirst: \(self.firstName)\nLast: \(self.lastName)\nPhoneNumber: \(self.phoneNumber)\nToken: \(String(describing: self.token))"
    }
}
