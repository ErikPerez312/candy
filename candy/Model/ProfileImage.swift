//
//  ProfileImage.swift
//  candy
//
//  Created by Erik Perez on 11/4/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

final class ProfileImage: NSObject {
    let id: Int
    let imageURL: String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let url = json["url"] as? String else {
                print("\n * ProfileImage -> Init: Failed")
                return nil
        }
        self.id = id
        self.imageURL = url
    }
}

extension ProfileImage {
    override var description: String {
        return "\nProfileImage:\n ID:\(id)\n imageURL:\(imageURL)\n"
    }
}
