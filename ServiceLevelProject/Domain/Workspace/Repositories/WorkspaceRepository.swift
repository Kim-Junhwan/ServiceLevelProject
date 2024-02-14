//
//  WorkspaceRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation

protocol WorkspaceRepository {
    func fetchComeInWorkspaceList() async throws -> WorkspaceList
    func createWorkspace(_ query: CreateWorkspaceQuery) async throws -> WorkSpaceThumbnail
    func editWorkspace(_ query: EditWorkspaceQuery) async throws -> WorkSpaceThumbnail
}
