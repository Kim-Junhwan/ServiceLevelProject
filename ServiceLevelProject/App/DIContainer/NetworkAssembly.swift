//
//  NetworkAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/07.
//

import Foundation
import Swinject

class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthRepository.self) { _ in
            return DefaultAuthRepository()
        }
        
        container.register(WorkspaceRepository.self) { _ in
            return DefaultWorkspaceRepository()
        }
    }
}
