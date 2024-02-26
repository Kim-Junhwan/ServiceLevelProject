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
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$selectWorkspace
            .receive(on: RunLoop.main)
            .sink { detailInfo in
                self.state.workspaceMembers = detailInfo?.workspaceMembers.filter{ $0.id != self.appState.userData.id }.map{ UserThumbnailModel(userThumnail: $0) } ?? []
        }
        .store(in: &cancellableBag)
    }
    
    func trigger(_ input: DMViewModelInput) {
        
    }
}
