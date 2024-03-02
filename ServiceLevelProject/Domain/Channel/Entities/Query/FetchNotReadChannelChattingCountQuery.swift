//
//  FetchNotReadChannelChattingCount.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct FetchNotReadChannelChattingCountQuery {
    let workspaceId: Int
    let channelName: String
    let cursorDate: Date
}
