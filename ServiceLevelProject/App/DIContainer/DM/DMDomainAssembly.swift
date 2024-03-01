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
        let dmRepository = container.resolve(DirectMessageRepository.self)!
        container.register(FetchWorkspaceComeInChannelDMListUseCase.self) { resolver in
            return DefaultFetchWorkspaceComeInChannelDMListUseCase(channelRepository: channelRepository, dmRepository: dmRepository)
        }
        container.register(CreateChannelUseCase.self) { _ in
            return DefaultCreatChannelUseCase(channelRepository: channelRepository)
        }
        container.register(SendDMChattingUsecase.self) { resolver in
            let chattingRepository = resolver.resolve(ChattingRepository.self)!
            return DefaultSendDMChattingUsecase(chattingRepository: chattingRepository, dmRepository: dmRepository)
        }
        container.register(FetchEnterDMChatListUsecase.self) { resolver in
            let chattingRepository = resolver.resolve(ChattingRepository.self)!
            return DefaultFetchEnterDMChatListUsecase(chattingRepository: chattingRepository, dmReposiotry: dmRepository)
        }
        container.register(FetchDMRoomListUsecase.self) { _ in
            return DefaultFetchDMRoomListUsecase(dmRepository: dmRepository)
        }
    }
    
}
