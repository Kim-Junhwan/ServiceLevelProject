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
    
    func postChatting(_ query: PostChattingQuery) async throws -> ChannelChatting {
        let value = try await SSAC.upload(multipartFormData: { multipartFormData in
            if let content = query.content {
                multipartFormData.append(Data(content.utf8), withName: "content")
            }
            for imageData in query.files.enumerated() {
                multipartFormData.append(imageData.element, withName: "files", fileName: "\(imageData.offset).jpeg", mimeType: "image/jpeg")
            }
        }, with: ChannelRouter.postChatting(workspaceId: query.workspaceId, channelName: query.name), interceptor: TokenInterceptor())
            .slpSerializingDecodable(ChannelChattingResponseDTO.self, responseErrorMapper: PostChattingErrorMapper()).value
        return try value.toDomain()
    }
    
    func fetchChannelChatting(_ query: FetchChannelChattingFromServerQuery) async throws -> [ChannelChatting] {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.fetchChannelChattingList(workspaceId: query.workspaceId, channelName: query.channelName, cursorDate: query.cursorDate)).slpSerializingDecodable([ChannelChattingResponseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.map{ try $0.toDomain() }
    }
    
    func fetchNotReadChanntChattingCount(_ query: FetchNotReadChannelChattingCountQuery) async throws -> Int {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.fetchNotReadChattingCount(workspaceId: query.workspaceId, channelName: query.channelName, cursorDate: query.cursorDate)).slpSerializingDecodable(NotReadChattingCountResponseDTO.self, responseErrorMapper: MissingDataErrorMapper()).value
        
        return value.count
    }
    
}
