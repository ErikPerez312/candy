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
    case password
    case phoneVerification
}

struct Statement {
    var statement: String
    var key: StatementKey
    
    static var registrationStatements: [Statement] {
        let firstName = Statement(statement: "What is your first name?", key: .firstName)
        let lastName = Statement(statement: "What is your last name?", key: .lastName)
        let password = Statement(statement: "Enter a password", key: .password)
        let phoneNumber = Statement(statement: "Enter your phone number", key: .phoneNumber)
        let phoneVerification = Statement(statement: "Enter code", key: .phoneVerification)
        return [firstName, lastName, password, phoneNumber, phoneVerification]
    }
}
