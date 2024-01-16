//
//  UserLoginStatusManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/16.
//

import Foundation

final class UserLoginStatusManager: LoginInfoRepository, ObservableObject {
    
    private var loginTypeKey = "loginKey"
    
    var loginType: LoginType {
        get {
            let value = UserDefaults.standard.object(forKey: loginTypeKey) as? String ?? LoginType.none.rawValue
            return LoginType(rawValue: value) ?? LoginType.none
        }
        set {
            switch loginType {
            case .email(let email, let password):
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.set(newValue.rawValue, forKey: loginTypeKey)
            default:
                UserDefaults.standard.set(newValue.rawValue, forKey: loginTypeKey)
            }
        }
    }
    
    @Published var isLoggedIn: Bool = false
    
    func saveToken(accessToken: String, refreshToken: String?) {
        <#code#>
    }
    
    
}
