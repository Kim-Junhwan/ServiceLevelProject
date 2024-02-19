//
//  EmailValidator.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import Foundation

struct Validator {
    
    enum ValidateCase {
        case email
        case nick
        case phoneNumber
        case password
        case workspaceName
        
        var regex: String {
            switch self {
            case .email:
                return "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com$"
            case .nick, .workspaceName:
                return #"^[\w\d가-힣]{1,30}$"#
            case .phoneNumber:
                return "^01[0-9]-([0-9]{3,4})-([0-9]{4})$"
            case .password:
                return "^(?=.*[A-Z])(?=.*[a-z])(?=.*[~!@#$%^&*])(?=.*[0-9]).{8,}"
            }
        }
    }
    
    static func isValid(category: ValidateCase, _ value: String) -> Bool {
        let result = value.range(of: category.regex, options: .regularExpression) != nil
        return result
    }
}
