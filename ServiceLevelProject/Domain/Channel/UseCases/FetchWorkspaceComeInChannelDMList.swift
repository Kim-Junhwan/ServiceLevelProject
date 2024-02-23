//
//  FetchWorkspaceComeInChannelDMList.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation

protocol FetchWorkspaceComeInChannelDMListUseCase {
    func excute(workspaceId: Int) async throws -> ComeInChannelDMList
}

final class DefaultFetchWorkspaceComeInChannelDMListUseCase {
    let channelRepository: ChannelRepository
    let dmRepository: DirectMessageRepository
    
    init(channelRepository: ChannelRepository, dmRepository: DirectMessageRepository) {
        self.channelRepository = channelRepository
        self.dmRepository = dmRepository
    }
}

extension DefaultFetchWorkspaceComeInChannelDMListUseCase: FetchWorkspaceComeInChannelDMListUseCase {
    func excute(workspaceId: Int) async throws -> ComeInChannelDMList {
        async let channelList = channelRepository.fetchComeInChannel(.init(workspaceId: workspaceId))
        async let dmList = dmRepository.fetchDirectMessageRoomList(.init(workspaceId: workspaceId))
        return try await ComeInChannelDMList(comeInChannelList: channelList, dmList: dmList)
    }
    
    
}
