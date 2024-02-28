//
//  ChattingAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation
import RealmSwift
import Swinject

final class ChattingAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(Realm.self) { _ in
            guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("slp.realm", conformingTo: .data) else {fatalError()}
            do {
                let bundleRealm = try Realm(fileURL: realmPath)
                return bundleRealm
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        .inObjectScope(.container)
        
        container.register(ChattingRepository.self) { resolver in
            let realm = resolver.resolve(Realm.self)!
            return RealmChattingRepository(realm: realm)
        }
        .inObjectScope(.container)
    }
}
