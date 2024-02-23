//
//  ChatDomainAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Swinject

final class ChatDomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FetchWorkspaceComeInChannelDMListUseCase.self) { resolver in
            let channelRepository = resolver.resolve(ChannelRepository.self)!
            let dmRepository = resolver.resolve(DirectMessageRepository.self)!
            return DefaultFetchWorkspaceComeInChannelDMListUseCase(channelRepository: channelRepository, dmRepository: dmRepository)
        }
    }
    
}
