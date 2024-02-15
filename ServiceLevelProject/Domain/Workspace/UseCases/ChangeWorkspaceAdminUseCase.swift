//
//  ChangeWorkspaceAdmin.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import Foundation

protocol ChangeWorkspaceAdminUseCase {
    func fetchWorkspaceMember(_ query: FetchWorkspaceMembersQuery) async throws -> [UserThumbnail]
}

final class DefaultChangeWorkspaceAdminUseCase {
    let workspaceRepository: WorkspaceRepository
    let appState: AppState
    
    init(workspaceRepository: WorkspaceRepository, appState: AppState) {
        self.workspaceRepository = workspaceRepository
        self.appState = appState
    }
}

extension DefaultChangeWorkspaceAdminUseCase: ChangeWorkspaceAdminUseCase {
    func fetchWorkspaceMember(_ query: FetchWorkspaceMembersQuery) async throws -> [UserThumbnail] {
        let fetchMembers = try await workspaceRepository.fetchWorkspaceMembers(query)
        let filteringMembers = fetchMembers.filter { $0.id != appState.userData.id }
        return filteringMembers
    }
}
