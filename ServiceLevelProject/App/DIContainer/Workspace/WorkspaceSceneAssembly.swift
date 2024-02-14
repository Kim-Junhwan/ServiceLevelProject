//
//  WorkspaceSceneAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/09.
//

import Swinject

class WorkspaceSceneAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(WorkspaceInializeViewModel.self) { resolver in
            let createWorkspaceUseCase = container.resolve(CreateWorkspaceUseCase.self)!
            return WorkspaceInializeViewModel(createWorkspaceUseCase: createWorkspaceUseCase)
        }
        
        container.register(WorkspaceEditViewModel.self) { resolver, title, description, imageData, id in
            let editWorkspaceUseCase = resolver.resolve(EditWorkspaceUseCase.self)!
            return WorkspaceEditViewModel(editWorkspaceUseCase: editWorkspaceUseCase, title: title, description: description, imageData: imageData, id: id)
        }
    }
}
