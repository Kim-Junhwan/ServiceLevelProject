//
//  DMSceneAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation

import Swinject

class DMSceneAssembly: Assembly {
    func assemble(container: Container) {
        let appState = container.resolve(AppState.self)!
        container.register(DMViewModel.self) { resolver in
            return DMViewModel(appState: appState)
        }
    }
}
