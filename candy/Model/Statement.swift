//
//  Statement.swift
//  candy
//
//  Created by Erik Perez on 8/13/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

enum StatementKey: String {
    case firstName
    case lastName
    case phoneNumber
    case age
    case gender
    case seeking
    case password
    case phoneVerification
    
    var values: [String]? {
        switch self {
        case .gender: return ["Male", "Female"]
        case .seeking: return ["Men", "Women", "Both"]
        case .age: return ["18", "19", "20", "21", "22"]
        default:
            return nil
        }
    }
}

struct Statement {
    var statement: String
    var key: StatementKey
    
    static var registrationStatements: [Statement] {
        let firstName = Statement(statement: "What is your first name?", key: .firstName)
        let lastName = Statement(statement: "What is your last name?", key: .lastName)
        let age = Statement(statement: "What is your age?", key: .age)
        let gender = Statement(statement: "What is your gender?", key: .gender)
        let seeking = Statement(statement: "Who are you seeking?", key: .seeking)
        let password = Statement(statement: "Enter a password", key: .password)
        let phoneNumber = Statement(statement: "Enter your phone number", key: .phoneNumber)
        let phoneVerification = Statement(statement: "Enter code", key: .phoneVerification)
        return [firstName, lastName, age, gender, seeking, password, phoneNumber, phoneVerification]
    }
}
