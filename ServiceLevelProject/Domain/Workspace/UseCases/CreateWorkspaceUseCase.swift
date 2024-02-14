//
//  CreateWorkspaceUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/10.
//

import Foundation

protocol CreateWorkspaceUseCase {
    func excute(_ query: CreateWorkspaceQuery) async throws
}

final class DefaultCreateWorkspaceUseCase {
    let appState: AppState
    let workspaceRepository: WorkspaceRepository
    
    init(appState: AppState, workspaceRepository: WorkspaceRepository) {
        self.appState = appState
        self.workspaceRepository = workspaceRepository
    }
}

extension DefaultCreateWorkspaceUseCase: CreateWorkspaceUseCase {
    func excute(_ query: CreateWorkspaceQuery) async throws {
        let _ = try await workspaceRepository.createWorkspace(query)
        let fetchWorkspaceList = try await workspaceRepository.fetchComeInWorkspaceList()
        DispatchQueue.main.async {
            self.appState.workspaceList = fetchWorkspaceList.list
        }
    }
    
}
