//
//  DMChattingResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct DMChattingResponseDTO: Decodable {
    let dmId: Int
    let roomId: Int
    let content: String?
    let createdAt: String
    let files: [String]
    let user: UserThumbnailResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case dmId = "dm_id"
        case roomId = "room_id"
        case content
        case createdAt
        case files
        case user
    }
    
    func toDomain() throws -> DMChatting {
        return .init(dmId: dmId, roomId: roomId, content: content, createdAt: try createdAt.toDate(), files: files, user: user.toDomain())
    }
}
