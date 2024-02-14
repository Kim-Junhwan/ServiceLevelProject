//
//  WorkspaceList.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation

struct WorkspaceList {
    var list: [WorkSpaceThumbnail]
}

struct WorkSpaceThumbnail {
    let id: Int
    let name: String
    let description: String?
    let thumbnailPath: String
    let ownerId: Int
    let createAt: Date
}
