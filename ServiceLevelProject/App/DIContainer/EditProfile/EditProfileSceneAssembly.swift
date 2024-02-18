//
//  EditProfileSceneAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/16.
//

import Swinject

class EditProfileSceneAssembly: Assembly {
    func assemble(container: Container) {
        let appState = container.resolve(AppState.self)!
        container.register(EditProfileViewModel.self) { _, imageData in
            return EditProfileViewModel(appState: appState, imageData: imageData)
        }
    }
}
