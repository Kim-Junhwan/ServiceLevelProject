//
//  AppStateAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/08.
//

import Foundation
import Swinject

final class AppStateAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppState.self) { _ in
            return AppState()
        }
        .inObjectScope(.container)
    }
}
