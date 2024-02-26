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
    let createdAt: Date
    let user: UserThumbnailModel
    var newMessageCount: Int
    
    init(dm: DirectMessageRoom) {
        workspaceId = dm.workspaceId
        id = dm.roomId
        createdAt = dm.createdAt
        user = .init(userThumnail: dm.user)
        newMessageCount = 0
    }
}
