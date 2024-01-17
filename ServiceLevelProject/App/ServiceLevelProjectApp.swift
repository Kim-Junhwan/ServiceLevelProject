//
//  ServiceLevelProjectApp.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/02.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct ServiceLevelProjectApp: App {
    
    @StateObject private var loginStatusManager = UserLoginStatusManager()
    
    init() {
        let kakaokAPIKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaokAPIKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            if loginStatusManager.isLoggedIn {
                
            } else {
                OnBoardingView()
                    .environmentObject(loginStatusManager)
                    .onOpenURL(perform: { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    })
            }
        }
    }
}
