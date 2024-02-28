//
//  ServiceLevelProjectApp.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/02.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import Swinject

@main
struct ServiceLevelProjectApp: App {
    
    init() {
        let kakaokAPIKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaokAPIKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SharedAssembler.shared.resolve(AppState.self))
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}
