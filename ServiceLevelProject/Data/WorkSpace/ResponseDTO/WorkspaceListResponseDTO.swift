//
//  WorkspaceListResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation

struct WorkspaceListResponseDTO: Decodable {
    let workspaceId: Int
    let name: String
    let description:String
    let thumbnail: String
    let ownerId: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case thumbnail
        case ownerId = "owner_id"
        case createdAt
    }
}
