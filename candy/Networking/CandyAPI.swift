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
    
    static let webSocketURL = URL(string: "wss://video-dating.herokuapp.com/cable")!

    static var webSocketOrigin: String {
        return baseURLString
    }
    
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
    
    static func deleteUser(withID id: String, completionHandler handler: @escaping (Int?) -> Void) {
        // TODO: Refactor. Breaking DRY principle. Update basic request method.
        do {
            let resource = Resource.deleteUser(id: id)
            let url = try buildURL(withBaseURLString: baseURLString, resource: resource)
            var request = URLRequest(url: url)
            request.httpMethod = resource.httpRequest.rawValue
            request.httpBody = resource.body
            request.allHTTPHeaderFields = resource.header
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let urlResponse = response as? HTTPURLResponse else {
                    handler(nil)
                    return
                }
                
                handler(urlResponse.statusCode)

                }.resume()
        } catch {
            // Catches possible errors thrown by buildURL(withBaseURLString:resource:)
            handler(nil)
        }
    }
    
    static func downloadImage(withLink link: String, completionHandler handler: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: link) else {
            handler(nil)
            return
        }
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    handler(nil)
                    return
            }
            handler(image)
        }.resume()
    }
    
    // MARK: - Private
    
    private static let baseURLString = "https://video-dating.herokuapp.com"
    
    // TODO: Refactor to return data instead of JSON
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
            // Catches possible errors thrown by buildURL(withBaseURLString:resource:)
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
                throw CandyAPIError.invalidParameter(key, value)
            }
            return URLQueryItem(name: key, value: v.description)
        }

        guard let finalURL = components.url else {
            throw CandyAPIError.invalidURL(resource.path)
        }
        return finalURL
    }
}
