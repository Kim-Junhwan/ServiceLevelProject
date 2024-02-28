//
//  DefaultChanngelRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation
import Alamofire

final class DefaultChannelRepository: ChannelRepository {
    
    func fetchComeInChannel(_ query: FetchComInChannelQuery) async throws -> [ChannelThumbnail] {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.fetchComeInChannel(query.workspaceId)).slpSerializingDecodable([ChannelThumbnailResponseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.map{try $0.toDomain()}
    }
    
    func createChannel(_ query: CreateChannelQuery) async throws -> ChannelThumbnail {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.createChannel(workspaceId: query.workspaceId, query: .init(name: query.channelName, description: query.channelDescription))).slpSerializingDecodable(ChannelThumbnailResponseDTO.self, responseErrorMapper: CreateChannelErrorMapper()).value
        return try value.toDomain()
    }
    
    func fetchWorkspaceChannel(_ query: FetchWorkspaceChannelQuery) async throws -> [ChannelThumbnail] {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.fetchWorkspaceChannel(workspaceId: query.workspaceId)).slpSerializingDecodable([ChannelThumbnailResponseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.map{ try $0.toDomain() }
    }
    
    func fetchDetailChannel(_ query: FetchDetailChannelInfoQuery) async throws -> DetailChannelInfo {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.fetchDetailChannelInfo(workspaceId: query.workspaceId, channelName: query.channelName)).slpSerializingDecodable(DetailChannelInfoResponseDTO.self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.toDomain()
    }
}
