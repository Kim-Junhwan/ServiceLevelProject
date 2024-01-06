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
    
    init() {
        KakaoSDK.initSDK(appKey: SecretKey.KAKAO_NATIVE_APP_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}
