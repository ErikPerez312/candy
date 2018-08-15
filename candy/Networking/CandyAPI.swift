//
//  CandyAPI.swift
//  candy
//
//  Created by Erik Perez on 8/8/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation
import RxSwift

enum CandyAPIError: Error {
    case invalidURL(String), invalidParameter(String, Any), invalidJSON(String)
}

class CandyAPI {
    
    typealias JSONDictionary = [String: Any]
    typealias CompletionHandler = (JSONDictionary?, Error?) -> Void
    
    static func signIn(withPhoneNumber phoneNumber: String, password: String,
                       completionHandler handler: @escaping CompletionHandler) {
        request(withResource: .logIn(withPhoneNumber: phoneNumber, password: password),
                completionHandler: handler)
    }
    
    static func register(withUserDict userDict: [String: Any],
                         completionHandler handler: @escaping CompletionHandler) {
        request(withResource: .register(withUserObject: userDict), completionHandler: handler)
    }
    
    static func requestVerificationCode(withPhoneNumber phoneNumber: String,
                                        completionHandler handler: CompletionHandler?) {
        let defaultHandler: (JSONDictionary?, Error?) -> Void = { json, error in
        }
        request(withResource: .requestVerificationCode(withNumber: phoneNumber), completionHandler: handler ?? defaultHandler)
    }
    
    static func verifyVerificationCode(withPhoneNumber phoneNumber: String,
                                       code: String,
                                       completionHandler handler: @escaping CompletionHandler) {
        request(withResource: .verifyVerificationCode(code: code, number: phoneNumber),
                completionHandler: handler)
    }
    
    // MARK: - Private
    
    private static let baseURLString = "https://video-dating.herokuapp.com"
    
    private static func request(withResource resource: Resource,
                                completionHandler handler: @escaping CompletionHandler) {
        do {
            let url = try buildURL(withBaseURLString: baseURLString, resource: resource)
            var request = URLRequest(url: url)
            request.httpMethod = resource.httpRequest.rawValue
            request.httpBody = resource.body
            request.allHTTPHeaderFields = resource.header
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    handler(nil, error)
                    return
                }
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = json as? JSONDictionary else {
                        handler(nil, CandyAPIError.invalidJSON(resource.path))
                        return
                }
                handler(result, nil)
            }.resume()
        } catch {
            handler(nil, error)
        }
    }
    
    private static func buildURL(withBaseURLString baseURLString: String, resource: Resource) throws -> URL {
        guard let url = URL(string: baseURLString)?.appendingPathComponent(resource.path),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw CandyAPIError.invalidURL(resource.path)
        }
        components.queryItems = try? resource.parameters.map { key, value in
            guard let v = value as? CustomStringConvertible else {
                throw CandyAPIError.invalidURL(resource.path)
            }
            return URLQueryItem(name: key, value: v.description)
        }

        guard let finalURL = components.url else {
            throw CandyAPIError.invalidURL(resource.path)
        }
        return finalURL
    }
}
