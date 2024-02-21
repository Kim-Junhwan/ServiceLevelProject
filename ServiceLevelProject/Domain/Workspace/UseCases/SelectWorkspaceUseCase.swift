//
//  SelectWorkspaceUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/22.
//

import Foundation

protocol SelectWorkspaceUseCase {
    func excute(workspaceId: Int) async throws
}

class DefaultSelectWorkspaceUseCase: SelectWorkspaceUseCase {
    let appState: AppState
    let workspaceRespotory: WorkspaceRepository
    
    init(appState: AppState, workspaceRespotory: WorkspaceRepository) {
        self.appState = appState
        self.workspaceRespotory = workspaceRespotory
    }
    
    func excute(workspaceId: Int) async throws {
        let fetchWorkspaceInfo = try await workspaceRespotory.fetchDetailWorkspace(.init(workspaceId: workspaceId))
        print(fetchWorkspaceInfo)
        appState.selectWorkspace(workspaceId: workspaceId, detailWorkspaceInfo: fetchWorkspaceInfo)
    }
}
