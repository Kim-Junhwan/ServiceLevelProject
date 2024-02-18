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
            AuthAssembly(),
            WorkspaceAssembly(),
            ChatAssembly(),
            EditProfileAssembly()
        ])
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        assembler.resolver.resolve(type)!
    }
    
    func resolve<T, Arg1>(_ type: T.Type, argument: Arg1) -> T {
        assembler.resolver.resolve(type, argument: argument)!
    }
    
    func resolve<T, Arg1, Arg2>(_ type: T.Type, argument: Arg1, arg2: Arg2) -> T {
        assembler.resolver.resolve(type, arguments: argument, arg2)!
    }
    
    func resolve<T, Arg1, Arg2, Arg3>(_ type: T.Type, argument: Arg1, arg2: Arg2, arg3: Arg3) -> T {
        assembler.resolver.resolve(type, arguments: argument, arg2, arg3)!
    }
    
    func resolve<T, Arg1, Arg2, Arg3, Arg4>(_ type: T.Type, argument: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> T {
        assembler.resolver.resolve(type, arguments: argument, arg2, arg3, arg4)!
    }
}
