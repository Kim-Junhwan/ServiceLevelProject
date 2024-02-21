//
//  ChannelThumbnailResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/22.
//

import Foundation

struct ChannelThumbnailResponseDTO: Decodable {
    let workspaceId: Int
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let isSecret: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case channelId = "channel_id"
        case name
        case description
        case ownerId = "owner_id"
        case isSecret = "private"
        case createdAt
    }
    
    func toDomain() throws -> ChannelThumbnail {
        return .init(workspaceId: self.workspaceId, channelId: channelId, name: name, description: description, ownerId: ownerId, secret: isSecret == 0 ? false : true, createdAt: try createdAt.toDate())
    }
}
