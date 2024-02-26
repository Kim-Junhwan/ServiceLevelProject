//
//  InviteMemberUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation

protocol InviteMemberUsecase {
    func excute(workspaceId: Int, inviteEmail: String) async throws
}

final class DefaultInviteMemberUsecase {
    let appState: AppState
    let workspaceRepository: WorkspaceRepository
    
    init(appState: AppState, workspaceRepository: WorkspaceRepository) {
        self.appState = appState
        self.workspaceRepository = workspaceRepository
    }
}

extension DefaultInviteMemberUsecase: InviteMemberUsecase {
    func excute(workspaceId: Int, inviteEmail: String) async throws {
        let _ = try await workspaceRepository.inviteMember(.init(workspaceId: workspaceId, inviteMemberEmail: inviteEmail))
        let fetchMembers = try await workspaceRepository.fetchWorkspaceMembers(.init(workspaceId: workspaceId))
        appState.selectWorkspace?.workspaceMembers = fetchMembers
    }
    
    
}
