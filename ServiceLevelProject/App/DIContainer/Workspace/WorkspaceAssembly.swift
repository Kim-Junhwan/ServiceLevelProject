//
//  WorkspaceAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/09.
//

import Swinject

final class WorkspaceAssembly: Assembly {
    func assemble(container: Container) {
        let assemblys: [Assembly] = [WorkspaceSceneAssembly(), WorkspaceDomainAssembly()]
        assemblys.forEach { $0.assemble(container: container) }
    }
}
