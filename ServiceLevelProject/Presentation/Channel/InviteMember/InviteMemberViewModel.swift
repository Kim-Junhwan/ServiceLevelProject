//
//  InviteMemberViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation

final class InviteMemberViewModel: ViewModel, ObservableObject {
    enum InviteMemberInput {
        case tapInviteButton
    }
    
    struct InviteMemberState {
        var toast: Toast?
        var email: String = ""
        var successInviteMember: Bool = false
    }
    @Published var state: InviteMemberState = .init()
    let inviteMemberUsecase: InviteMemberUsecase
    let appState: AppState
   
    init(inviteMemberUsecase: InviteMemberUsecase, appState: AppState) {
        self.inviteMemberUsecase = inviteMemberUsecase
        self.appState = appState
    }
    
    func trigger(_ input: InviteMemberInput) {
        switch input {
        case .tapInviteButton:
            inviteMember()
        }
    }
    
    private func inviteMember() {
        guard let workspaceId = appState.selectWorkspace?.workspaceId else { return }
        Task {
            do {
                try await inviteMemberUsecase.excute(workspaceId: workspaceId, inviteEmail: state.email)
                self.state.successInviteMember = true
            } catch {
                DispatchQueue.main.async {
                        self.state.toast = .init(message: error.localizedDescription, duration: 1.0)
                }
            }
        }
    }
}
