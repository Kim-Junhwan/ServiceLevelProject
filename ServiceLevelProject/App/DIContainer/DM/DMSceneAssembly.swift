//
//  DMSceneAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation

import Swinject

class DMSceneAssembly: Assembly {
    func assemble(container: Container) {
        let appState = container.resolve(AppState.self)!
        container.register(DMViewModel.self) { resolver in
            let dmRepository = resolver.resolve(DirectMessageRepository.self)!
            return DMViewModel(appState: appState, dmRepository: dmRepository)
        }
        container.register(DMChattingViewModel.self) { resolver,  userInfo in
            let sendUsecase = resolver.resolve(SendDMChattingUsecase.self)!
            let fetchChatUsecase = resolver.resolve(FetchEnterDMChatListUsecase.self)!
            return DMChattingViewModel(appState: appState, fetchEnterDMChattingUsecase: fetchChatUsecase, sendDMChattingUsecase: sendUsecase, user: userInfo)
        }
    }
}
