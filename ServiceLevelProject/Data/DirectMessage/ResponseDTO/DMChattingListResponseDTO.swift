//
//  DMChattingListResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct DMChattingListResponseDTO: Decodable {
    let workspaceId: Int
    let roomId: Int
    let chats: [DMChattingResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case roomId = "room_id"
        case chats
    }
    
    func toDomain() throws -> DMChattingList {
        return .init(workspaceId: workspaceId, roomId: roomId, chats: try chats.map{ try $0.toDomain() })
    }
}
