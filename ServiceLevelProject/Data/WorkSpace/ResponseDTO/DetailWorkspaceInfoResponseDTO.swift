//
//  DetailWorkspaceInfoResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/21.
//

import Foundation

struct DetailWorkspaceInfoResponseDTO: Decodable {
    let workspaceId: Int
    let name: String
    let description:String
    let thumbnail: String
    let ownerId: Int
    let createdAt: String
    let channels: [ChannelThumbnailResponseDTO]
    let workspaceMembers: [UserThumbnailResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case thumbnail
        case ownerId = "owner_id"
        case createdAt
        case channels
        case workspaceMembers
    }
    
    func toDomain() throws -> WorkspaceDetailInfo {
        return .init(workspaceId: workspaceId, name: name, description: description, thumbnail: thumbnail, ownerId: ownerId, createdAt: try createdAt.toDate(), channels: try channels.map{try $0.toDomain()}, workspaceMembers: workspaceMembers.map{$0.toDomain()})
    }
}
