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
        var successCreateWorkspace: Bool = false
        var toast: Toast?
    }
    
    @Published var state: WorkSpaceEditState = .init()
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var imageModel: ImagePickerModel
    private var cancellableBag = Set<AnyCancellable>()
    
    init(title: String, description: String?, imageData: Data) {
        self.title = title
        self.description = description ?? ""
        self.imageModel = .init(maxSize: 70, imageData: imageData)
    }
    
    func trigger(_ input: WorkSpaceEditState) {
        
    }
}
