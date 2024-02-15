//
//  EditWorkspaceQuery.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/14.
//

import Foundation

struct EditWorkspaceQuery {
    let workspaceId: Int
    let name: String
    let description: String?
    let imageData: Data
}
