//
//  DIContainer.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/18.
//

import Foundation

class DIContainer {
    
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
}
