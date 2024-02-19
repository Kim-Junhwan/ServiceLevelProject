//
//  WorkspaceSideMenuViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Foundation
import Combine

struct WorkspaceThumbnailModel {
    let workspaceId: Int
    let title: String
    let createdAt: String
    let imagePath: String
    let ownerId: Int
    let description: String?
    
    init(workspace: WorkSpaceThumbnail) {
        self.workspaceId = workspace.id
        self.title = workspace.name
        self.description = workspace.description
        self.ownerId = workspace.ownerId
        self.createdAt = DateFormatter.yearMonthDateFormatter.string(from: workspace.createAt)
        self.imagePath = workspace.thumbnailPath
    }
}

final class WorkspaceSideMenuViewModel: ViewModel {
    enum WorkSpaceSideMenuInput {
        case tapWorkspace(WorkspaceThumbnailModel)
    }
    
    struct WorkspaceSideMenuState {
        var selectedWorkspace: WorkspaceThumbnailModel?
        var workspaceList: [WorkspaceThumbnailModel]
        var workspaceIsEmpty: Bool
        var selectWorkspaceOwner: Bool = false
    }
    
    @Published var state: WorkspaceSideMenuState
    private let appState: AppState
    private var cancellableBag = Set<AnyCancellable>()
    
    init(appState: AppState) {
        self.state = .init(workspaceList: appState.workspaceList.map{.init(workspace: $0)}, workspaceIsEmpty: appState.workspaceList.isEmpty)
        self.appState = appState
        appStateBind()
    }
    
    func appStateBind() {
        appState.$workspaceList
            .receive(on: RunLoop.main)
            .sink { workspaceList in
                self.state.workspaceIsEmpty = workspaceList.isEmpty
                self.state.workspaceList = workspaceList.map{ .init(workspace: $0) }
            }
            .store(in: &cancellableBag)
        
        appState.$selectWorkspace
            .receive(on: RunLoop.main)
            .sink { selectWorkspaceDomainModel in
                guard let selectWorkspace = selectWorkspaceDomainModel else { return }
                self.state.selectedWorkspace = .init(workspace: selectWorkspace)
                self.state.selectWorkspaceOwner = selectWorkspace.ownerId == self.appState.userData.id
            }
            .store(in: &cancellableBag)
    }
    
    func trigger(_ input: WorkSpaceSideMenuInput) {
        switch input {
        case .tapWorkspace(let workspaceThumbnailModel):
            appState.selectWorkspace(workspaceId: workspaceThumbnailModel.workspaceId)
        }
    }
}
