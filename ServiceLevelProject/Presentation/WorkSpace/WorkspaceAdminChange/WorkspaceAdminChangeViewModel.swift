//
//  WorkspaceAdminChangeViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//
import Foundation
import Combine

struct WorkspaceMemberModel: Identifiable {
    let id: UUID = .init()
    let userId: Int
    let email: String
    let nickname: String
    let profileImagePath: String?
}

class WorkspaceAdminChangeViewModel: ViewModel {
    enum WorkSpaceAdminChangeInput {
        case appearView
        case tapMember
    }
    
    struct WorkSpaceAdminChangeState {
        var canChangeWorkspaceAdmin: Bool = true
    }
    
    @Published var state: WorkSpaceAdminChangeState = .init()
    @Published var members: [WorkspaceMemberModel] = []
    private var cancellableBag = Set<AnyCancellable>()
    private let workspaceId: Int
    private let changeWorkspaceAdminUseCase: ChangeWorkspaceAdminUseCase
    
    init(workspaceId: Int, changeWorkspaceAdminUseCase: ChangeWorkspaceAdminUseCase) {
        self.workspaceId = workspaceId
        self.changeWorkspaceAdminUseCase = changeWorkspaceAdminUseCase
    }
    
    func trigger(_ input: WorkSpaceAdminChangeInput) {
        switch input {
        case .appearView:
            fetchWorkspaceMember()
        case .tapMember:
            break
        }
    }
    
    private func fetchWorkspaceMember() {
        Task { @MainActor in
            do {
                let value = try await changeWorkspaceAdminUseCase.fetchWorkspaceMember(.init(workspaceId: workspaceId))
                DispatchQueue.main.async {
                    if value.isEmpty {
                        self.state.canChangeWorkspaceAdmin = false
                    } else {
                        self.members = value.map{ .init(userId: $0.id, email: $0.email, nickname: $0.nickname, profileImagePath: $0.profileImagePath) }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
