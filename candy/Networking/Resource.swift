//
//  Resource.swift
//  candy
//
//  Created by Erik Perez on 8/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import UIKit

enum HTTPRequest: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Resource {
    case register(withUserObject: [String: Any])
    case logIn(withPhoneNumber: String, password: String)
    case requestVerificationCode(withNumber: String)
    case verifyVerificationCode(code: String, number: String)
    case deleteUser(id: String)
    
    var httpRequest: HTTPRequest {
        switch self {
        case .register,
             .requestVerificationCode,
             .verifyVerificationCode:
            return .post
        case .logIn:
            return .get
        case .deleteUser:
            return .delete
        }
    }
    
    var header: [String: String] {
        switch self {
        case .deleteUser:
            guard let token = KeychainHelper.fetch(.authToken) else { fallthrough }
            return ["Authorization": "Bearer \(token)"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var path: String {
        switch self {
        case .logIn: return "/session"
        case .register: return "/users"
        case .requestVerificationCode: return "/verification/code"
        case .verifyVerificationCode: return "/verification/verify"
        case let .deleteUser(id): return "/users/\(id)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .logIn(phoneNumber, password):
            return ["phone_number": phoneNumber, "password": password]
        default:
            return [:]
        }
    }
    
    var body: Data? {
        let serialize: ([String: Any]) -> Data? = { object in
            return try? JSONSerialization.data(withJSONObject: object, options: [])
        }
        switch self {
        case let .register(userObject):
            let json: [String: Any] = [
                "first_name": userObject["firstName"] as! String,
                "last_name": userObject["lastName"] as! String,
                "phone_number": userObject["phoneNumber"] as! String,
                "age": userObject["age"] as! String,
                "gender": userObject["gender"] as! Int,
                "seeking": userObject["seeking"] as! Int,
                "password": userObject["password"] as! String,
                ]
            return serialize(json)
        case let .requestVerificationCode(number):
            let json: [String: Any] = [
                "phone_number": number,
                "country_code": 1,
                "via": "sms",
                ]
            return serialize(json)
        case let .verifyVerificationCode(code, number):
            let json: [String: Any] = [
                "phone_number": number,
                "country_code": 1,
                "verification_code": code
            ]
            return serialize(json)
        default:
            return nil
        }
    }
}
