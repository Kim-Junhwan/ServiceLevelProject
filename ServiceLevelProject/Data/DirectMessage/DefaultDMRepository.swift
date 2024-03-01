//
//  DefaultDMRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation
import Alamofire

class DefaultDMRepository: DirectMessageRepository {
    
    func fetchDirectMessageRoomList(_ query: FetchDirectMessageRoomQuery) async throws -> [DirectMessageRoom] {
        let value = try await SSAC.accessTokenRequest(DirectMessageRouter.fetchDMSRoomList(query)).slpSerializingDecodable([DMRoomResonseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.map{ try $0.toDomain() }
    }
    
    func fetchDMChattingList(_ query: FetchDMChattingListQuery) async throws -> DMChattingList {
        let value = try await SSAC.accessTokenRequest(DirectMessageRouter.fetchDMChattingList(audienceId: query.audienceId, workspaceId: query.workspaceId, cursorDate: query.cursorDate)).slpSerializingDecodable(DMChattingListResponseDTO.self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.toDomain()
    }
    
    func postDMChatting(_ query: PostDMChattingQuery) async throws -> DMChatting {
        let value = try await SSAC.upload(multipartFormData: { multipartFormData in
            if let content = query.content {
                multipartFormData.append(Data(content.utf8), withName: "content")
            }
            for imageData in query.files.enumerated() {
                multipartFormData.append(imageData.element, withName: "files", fileName: "\(imageData.offset).jpeg", mimeType: "image/jpeg")
            }
        }, with: DirectMessageRouter.postChatting(roomId: query.roomId, workspaceId: query.workspaceId), interceptor: TokenInterceptor())
            .slpSerializingDecodable(DMChattingResponseDTO.self, responseErrorMapper: PostDMErrorMapper()).value
        return try value.toDomain()
    }
}
