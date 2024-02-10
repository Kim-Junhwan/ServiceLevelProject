//
//  AuthAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/09.
//

import Swinject

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        let assemblys: [Assembly] = [AuthSceneAssembly(), AuthDomainAssembly()]
        assemblys.forEach { $0.assemble(container: container) }
    }
}
