//
//  DetailChannelInfoResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct DetailChannelInfoResponseDTO: Decodable {
    let workspaceId: Int?
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let isSecret: Int
    let createdAt: String
    let channelMembers: [UserThumbnailResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case channelId = "channel_id"
        case name
        case description
        case ownerId = "owner_id"
        case isSecret = "private"
        case createdAt
        case channelMembers
    }
    
    func toDomain() throws -> DetailChannelInfo {
        return .init(workspaceId: workspaceId, channelId: channelId, name: name, description: description, ownerId: ownerId, isSecret: isSecret == 0 ? false : true, createdAt: try createdAt.toDate(), channelMembers: channelMembers.map{ $0.toDomain() })
    }
}
