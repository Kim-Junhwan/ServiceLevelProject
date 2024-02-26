//
//  DMViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation
import Combine

final class DMViewModel: ViewModel, ObservableObject {
    enum DMViewModelInput {
        
    }
    
    struct DMViewModelState {
        var workspaceMembers: [UserThumbnailModel] = []
        
    }
    
    @Published var state: DMViewModelState = .init()
    private let appState: AppState
    private var cancellableBag = Set<AnyCancellable>()
    
    init(appState: AppState) {
        self.appState = appState
        //guard let members = appState.selectWorkspace?.workspaceMembers.filter({ $0.id != appState.userData.id }) else { fatalError() }
        //self.state = .init(workspaceMembers: members.map{ .init(userThumnail: $0) })
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$selectWorkspace
            .receive(on: RunLoop.main)
            .sink { detailInfo in
            self.state.workspaceMembers = detailInfo?.workspaceMembers.map{ UserThumbnailModel(userThumnail: $0) } ?? []
        }
        .store(in: &cancellableBag)
    }
    
    func trigger(_ input: DMViewModelInput) {
        
    }
}
