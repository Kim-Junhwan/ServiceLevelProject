//
//  DMDomainAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Swinject

final class DMDomainAssembly: Assembly {
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
