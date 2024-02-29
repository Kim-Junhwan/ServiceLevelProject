//
//  PostDMChattingQuery.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct PostDMChattingQuery {
    let roomId: Int
    let workspaceId: Int
    let content: String?
    let files: [Data]
}
