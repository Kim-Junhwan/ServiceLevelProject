//
//  WorkspaceRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation

protocol WorkspaceRepository {
    func fetchComeInWorkspaceList() async throws -> WorkspaceList
}
