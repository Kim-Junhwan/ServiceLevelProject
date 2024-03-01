//
//  FetchNotReadChattingCountQuery.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct FetchNotReadChattingCountQuery {
    let roomId: Int
    let workspaceId: Int
    let cursorDate: Date?
}
