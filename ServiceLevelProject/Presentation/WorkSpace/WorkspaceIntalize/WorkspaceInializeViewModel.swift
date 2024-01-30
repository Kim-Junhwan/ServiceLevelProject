//
//  WorkspaceInializeViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/26.
//

import Foundation
import Combine

final class WorkspaceInializeViewModel: ViewModel {
    
    enum WorkSpaceInitalInput {
        case tapCompleteButton
    }
    
    struct WorkSpaceInitalState {
        var isValidTitle: Bool = true
        var canTapCompleteButton: Bool = false
    }
    
    @Published var state: WorkSpaceInitalState
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var imageModel = ImagePickerModel(maxSize: 70, imageData: nil)
    
    private var cancellableBag = Set<AnyCancellable>()
    
    init() {
        self.state = WorkSpaceInitalState()
        $title
            .receive(on: RunLoop.main)
            .map{ !$0.isEmpty }
            .sink { value in
                self.state.canTapCompleteButton = value
            }
            .store(in: &cancellableBag)
    }
    
    func trigger(_ input: WorkSpaceInitalInput) {
        switch input {
        case .tapCompleteButton:
            createWorkspace()
        }
    }
    
    private func createWorkspace() {
        
    }
}
