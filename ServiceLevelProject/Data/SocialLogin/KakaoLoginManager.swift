//
//  KakaoLoginManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/06.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon

enum KakaoLoginError: Error {
    case cannotFetchToken
}

@MainActor
struct KakaoLoginManager {
    
    typealias token = String
    
    private func loginWithKakaoTalk() async throws -> token {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                guard let oauthToken = token?.accessToken else {
                    return
                }
                continuation.resume(returning: oauthToken)
            }
        }
    }
    
    private func loginWithKakaoAccount() async throws -> token {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                guard let oauthToken = token?.accessToken else {
                    return
                }
                continuation.resume(returning: oauthToken)
            }
        }
    }
    
    func login() async throws -> token {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await loginWithKakaoTalk()
        } else {
            return try await loginWithKakaoAccount()
        }
    }
}
