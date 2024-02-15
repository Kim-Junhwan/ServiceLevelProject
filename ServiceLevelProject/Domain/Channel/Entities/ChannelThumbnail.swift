//
//  ChannelThumbnail.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import Foundation

struct ChannelThumbnail {
    let workspaceId: Int
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let secret: Bool?
    let createdAt: Date
}
