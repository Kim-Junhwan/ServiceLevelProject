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
            let selectWorkspaceUseCase = container.resolve(SelectWorkspaceUseCase.self)!
            return WorkspaceInializeViewModel(createWorkspaceUseCase: createWorkspaceUseCase, selectWorkspaceUseCase: selectWorkspaceUseCase)
        }
        
        container.register(WorkspaceEditViewModel.self) { resolver, title, description, imageUrl, id in
            let editWorkspaceUseCase = resolver.resolve(EditWorkspaceUseCase.self)!
            return WorkspaceEditViewModel(editWorkspaceUseCase: editWorkspaceUseCase, title: title, description: description, imageUrl: imageUrl, id: id)
        }
        
        container.register(WorkspaceAdminChangeViewModel.self) { resolver, workspaceId in
            let changeWorkspaceUseCase = resolver.resolve(ChangeWorkspaceAdminUseCase.self)!
            return WorkspaceAdminChangeViewModel(workspaceId: workspaceId, changeWorkspaceAdminUseCase: changeWorkspaceUseCase)
        }
        
        container.register(WorkspaceSideMenuViewModel.self) { resolver in
            let appState = resolver.resolve(AppState.self)!
            let selectWorkspaceUsecase = resolver.resolve(SelectWorkspaceUseCase.self)!
            return WorkspaceSideMenuViewModel(appState: appState, selectWorkspaceUseCase: selectWorkspaceUsecase)
        }
    }
}
