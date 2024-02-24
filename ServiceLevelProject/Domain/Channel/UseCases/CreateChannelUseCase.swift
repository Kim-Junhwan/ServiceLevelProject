//
//  CreateChannelUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/24.
//

import Foundation

protocol CreateChannelUseCase {
    func excute(workspaceId: Int, channelName: String, channelDescription: String?) async throws -> [ChannelThumbnail]
}

final class DefaultCreatChannelUseCase {
    let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
}

extension DefaultCreatChannelUseCase: CreateChannelUseCase {
    func excute(workspaceId: Int, channelName: String, channelDescription: String?) async throws -> [ChannelThumbnail] {
        let _ = try await channelRepository.createChannel(.init(workspaceId: workspaceId, channelName: channelName, channelDescription: channelDescription))
        let channelList = try await channelRepository.fetchComeInChannel(.init(workspaceId: workspaceId))
        return channelList
    }
}
