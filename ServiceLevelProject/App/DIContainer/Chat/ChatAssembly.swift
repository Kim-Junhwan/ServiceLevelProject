//
//  ChatAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/16.
//

import Swinject

final class ChatAssembly: Assembly {
    func assemble(container: Container) {
        let assemblys: [Assembly] = [ChatSceneAssembly(), ChatDomainAssembly()]
        assemblys.forEach { $0.assemble(container: container) }
    }
}
