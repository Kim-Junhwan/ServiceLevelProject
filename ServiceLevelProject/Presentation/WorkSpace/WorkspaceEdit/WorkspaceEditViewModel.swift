//
//  WorkspaceEditViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import Foundation
import Combine

class WorkspaceEditViewModel: ViewModel {
    enum WorkSpaceEditInput {
        case tapCompleteButton
    }
    
    struct WorkSpaceEditState {
        var isValidTitle: Bool = true
        var canTapCompleteButton: Bool = false
        var successEditWorkspace: Bool = false
        var toast: Toast?
    }
    
    @Published var state: WorkSpaceEditState = .init()
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var imageModel: ImagePickerModel
    private var cancellableBag = Set<AnyCancellable>()
    private let id: Int
    
    private let editWorkspaceUseCase: EditWorkspaceUseCase
    
    init(editWorkspaceUseCase: EditWorkspaceUseCase, title: String, description: String?, imageUrl: String, id: Int) {
        self.editWorkspaceUseCase = editWorkspaceUseCase
        self.title = title
        self.description = description ?? ""
        self.imageModel = .init(maxSize: 70, url: imageUrl)
        self.id = id
    }
    
    func trigger(_ input: WorkSpaceEditInput) {
        editWorkspace()
    }
    
    private func editWorkspace() {
        guard let imageData = imageModel.imageData else { return }
        Task {
            do {
                try await editWorkspaceUseCase.excute(.init(workspaceId: id, name: title, description: description, imageData: imageData))
                DispatchQueue.main.async {
                    self.state.toast = Toast(message: "워크스페이스가 편집되었습니다.", duration: 1.0)
                    self.state.successEditWorkspace = true
                }
            }
        }
    }
}
