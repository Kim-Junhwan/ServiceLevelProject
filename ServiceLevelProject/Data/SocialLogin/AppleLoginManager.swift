//
//  AppleLoginManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/06.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    
    weak var view: UIView?
    
    init(view: UIView) {
        self.view = view
    }
    
    func login() {
        let appleIDProvieder = ASAuthorizationAppleIDProvider()
        let request = appleIDProvieder.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension AppleLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (view?.window!)!
    }
    
    
}
