//
//  EditProfileAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/16.
//

import Swinject

final class EditProfileAssembly: Assembly {
    func assemble(container: Container) {
        let assemblys: [Assembly] = [EditProfileSceneAssembly()]
        assemblys.forEach { $0.assemble(container: container) }
    }
}
