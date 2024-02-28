//
//  PostChattingQuery.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct PostChattingQuery {
    let name: String
    let workspaceId: Int
    let content: String?
    let files: [Data]
}
