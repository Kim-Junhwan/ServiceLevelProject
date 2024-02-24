//
//  ChatDomainAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Swinject

final class ChatDomainAssembly: Assembly {
    func assemble(container: Container) {
        let channelRepository = container.resolve(ChannelRepository.self)!
        container.register(FetchWorkspaceComeInChannelDMListUseCase.self) { resolver in
            let dmRepository = resolver.resolve(DirectMessageRepository.self)!
            return DefaultFetchWorkspaceComeInChannelDMListUseCase(channelRepository: channelRepository, dmRepository: dmRepository)
        }
        
        container.register(CreateChannelUseCase.self) { _ in
            return DefaultCreatChannelUseCase(channelRepository: channelRepository)
        }
    }
    
}
