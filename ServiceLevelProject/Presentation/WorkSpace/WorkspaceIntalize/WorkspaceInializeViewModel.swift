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
        var successCreateWorkspace: Bool = false
        var toast: Toast?
    }
    
    @Published var state: WorkSpaceInitalState
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var imageModel = ImagePickerModel(maxSize: 70, imageData: nil)
    private var cancellableBag = Set<AnyCancellable>()
    
    let createWorkspaceUseCase: CreateWorkspaceUseCase
    let selectWorkspaceUseCase: SelectWorkspaceUseCase
    
    init(createWorkspaceUseCase: CreateWorkspaceUseCase, selectWorkspaceUseCase: SelectWorkspaceUseCase) {
        self.createWorkspaceUseCase = createWorkspaceUseCase
        self.selectWorkspaceUseCase = selectWorkspaceUseCase
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
        guard let imageData = imageModel.imageData else {
            state.toast = .init(message: "워크스페이스 이미지를 등록해주세요.", duration: 1.0)
            return
        }
        if !Validator.isValid(category: .workspaceName, title) {
            state.toast = .init(message: "워크스페이스 이름은 1~30자로 설정해주세요.", duration: 1.0)
        }
        
        Task {
            do {
                let createdWorkspace = try await createWorkspaceUseCase.excute(.init(name: title, description: description, image: imageData))
                try await selectWorkspaceUseCase.excute(workspaceId: createdWorkspace.id)
                DispatchQueue.main.async {
                    self.state.successCreateWorkspace = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.state.toast = .init(message: error.localizedDescription, duration: 1.0)
                }
            }
        }
    }
}
