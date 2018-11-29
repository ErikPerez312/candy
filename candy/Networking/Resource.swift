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
    case uploadProfileImage(imageInfo: CandyImageInfo)
    
    var httpRequest: HTTPRequest {
        switch self {
        case .register,
             .requestVerificationCode,
             .verifyVerificationCode,
             .uploadProfileImage:
            return .post
        case .logIn:
            return .get
        case .deleteUser:
            return .delete
        }
    }
    
    var header: [String: String] {
        guard let token = KeychainHelper.fetch(.authToken) else {
            fatalError("\n * Resource -> header: Failed to fetch user token")
        }
        switch self {
        case .deleteUser:
            return ["Authorization": "Bearer \(token)"]
        case let .uploadProfileImage(imageInfo):
            return ["Content-Type": "multipart/form-data; boundary=Boundary-\(imageInfo.boundary)",
                    "Authorization": "Bearer \(token)"]
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
        //FIXME: Update path when route has been updated in backend
        case .uploadProfileImage: return "/users/0/profile_images"
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
        case let .uploadProfileImage(imageInfo):
            // Huge thanks to NewFiveFour on GitHub
            // LINK: https://github.com/newfivefour/BlogPosts/blob/master/swift-form-data-multipart-upload-URLRequest.md
            var body = Data()
            body.append("--Boundary-\(imageInfo.boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"\(imageInfo.filename)\"\r\n")
            body.append("Content-type: image/png\r\n\r\n")
            body.append(imageInfo.imageData)
            body.append("\r\n")
            body.append("--Boundary-\(imageInfo.boundary)--\r\n")
            return body
        default:
            return nil
        }
    }
}
