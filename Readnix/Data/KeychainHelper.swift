//
//  KeychainHelper.swift
//  Readnix
//
//  Created by zarleonix on 11.05.2025.
// 

import Security
import Foundation

/// Утилита для работы с системой безопасности Keychain.
/// Предоставляет простой интерфейс для сохранения, чтения и удаления данных (например, токена).
/// Использует Security.framework (SecItemAdd, SecItemCopyMatching и т.д.)

final class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ value: String, service: String, account: String) {
        guard let data = value.data(using: .utf8) else { return }

        // Удалим старое значение, если оно есть
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        SecItemDelete(query)

        // Добавим новое
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
        SecItemAdd(attributes, nil)
    }

    func read(service: String, account: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string
    }

    func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        SecItemDelete(query)
    }
}
