//
//  SharedAssembler.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/08.
//

import Foundation
import Swinject

final class SharedAssembler {
    static let shared = SharedAssembler()
    
    private let assembler: Assembler
    
    private init() {
        self.assembler = Assembler([
            AppStateAssembly(),
            NetworkAssembly(),
            AuthAssembly()
        ])
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        assembler.resolver.resolve(type)!
    }
}
