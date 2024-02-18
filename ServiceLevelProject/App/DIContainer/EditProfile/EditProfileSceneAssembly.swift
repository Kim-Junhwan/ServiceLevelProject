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
        container.register(EditProfileViewModel.self) { resolver in
            let profileRepository = resolver.resolve(ProfileRepository.self)!
            return EditProfileViewModel(appState: appState, profileRepository: profileRepository)
        }
    }
}
