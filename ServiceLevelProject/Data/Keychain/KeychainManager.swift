//
//  KeychainStorage.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    enum KeychainError: Error {
        case itemNotFound
        case duplicateItem
        case invalidItemFormat
        case unhandledError(OSStatus)
    }
    
    func saveTokenAtKeyChain(key: String, value: String) throws {
        guard let decodeValue = value.data(using: String.Encoding.utf8) else { throw KeychainError.invalidItemFormat }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: decodeValue
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            if status == errSecDuplicateItem {
                try updateTokenValueAtKeyChain(key: key, value: value)
            } else {
                throw KeychainError.unhandledError(status)
            }
        }
    }
    
    func readTokenAtKeyChain(key: String) throws -> String {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true
                                    ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status) }
        guard let existingItem = item as? [String: Any],
              let originData = existingItem[kSecValueData as String] as? Data,
              let data = String(data: originData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.invalidItemFormat
        }
        return data
    }
    
    func deleteTokenAtKeyChain(key: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status) }
    }
    
    private func updateTokenValueAtKeyChain(key: String, value: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        let convertValue = value.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [kSecValueData as String: convertValue]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status) }
    }
}
