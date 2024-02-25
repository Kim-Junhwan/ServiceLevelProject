//
//  DMAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Swinject

final class DMAssembly: Assembly {
    func assemble(container: Container) {
        let assemblys: [Assembly] = [DMSceneAssembly(), DMDomainAssembly()]
        assemblys.forEach { $0.assemble(container: container) }
    }
}
