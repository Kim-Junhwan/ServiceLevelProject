//
//  DMRoomItemModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/25.
//

import Foundation
struct DMRoomItemModel: Hashable, Identifiable {
    
    let workspaceId: Int
    let id: Int
    let createdAt: String
    let user: UserThumbnailModel
    var newMessageCount: Int
    var thumbnailContent: String
    
    init(dm: DirectMessageRoom, thumbnailContent: String, newMessageCount: Int) {
        workspaceId = dm.workspaceId
        id = dm.roomId
        createdAt = DateFormatter.todatStandardFormatting(dm.createdAt)
        user = .init(userThumnail: dm.user)
        self.newMessageCount = newMessageCount
        self.thumbnailContent = thumbnailContent
    }
}
