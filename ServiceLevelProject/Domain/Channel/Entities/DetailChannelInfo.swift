//
//  DetailChannelInfo.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct DetailChannelInfo {
    let workspaceId: Int?
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let isSecret: Bool
    let createdAt: Date
    let channelMembers: [UserThumbnail]
}
