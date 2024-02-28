//
//  DetailChannelInfoModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct DetailChannelInfoModel {
    let workspaceId: Int?
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let isSecret: Bool
    let createdAt: Date
    let channelMembers: [UserThumbnailModel]
    
    init(_ detailChannelInfo: DetailChannelInfo) {
        workspaceId = detailChannelInfo.workspaceId
        channelId = detailChannelInfo.channelId
        name = detailChannelInfo.name
        description = detailChannelInfo.description
        ownerId = detailChannelInfo.ownerId
        isSecret = detailChannelInfo.isSecret
        createdAt = detailChannelInfo.createdAt
        channelMembers = detailChannelInfo.channelMembers.map { .init(userThumnail: $0) }
    }
}
