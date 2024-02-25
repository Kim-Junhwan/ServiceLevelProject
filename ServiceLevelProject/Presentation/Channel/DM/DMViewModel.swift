//
//  DMViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation

final class DMViewModel: ViewModel, ObservableObject {
    enum DMViewModelInput {
        
    }
    
    struct DMViewModelState {
        var workspaceMembers: [UserThumbnailModel]
        
    }
    
    @Published var state: DMViewModelState
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        guard let members = appState.selectWorkspace?.workspaceMembers.filter({ $0.id != appState.userData.id }) else { fatalError() }
        self.state = .init(workspaceMembers: members.map{ .init(userThumnail: $0) })
    }
    
    func trigger(_ input: DMViewModelInput) {
        
    }
}
