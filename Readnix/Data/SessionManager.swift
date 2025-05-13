//
//  SessionManager.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

/// Менеджер сессии приложения.
/// Отвечает за хранение и восстановление токена авторизации (из Keychain),
/// ID текущей библиотеки (из UserDefaults) и информации о пользователе.
/// Используется в SwiftUI через ObservableObject для отслеживания состояния авторизации.

final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    private let tokenKey = "authToken"
    private let libraryIdKey = "libraryId"

    @Published var authToken: String? {
        didSet {
            if let token = authToken {
                KeychainHelper.shared.save(token, service: "ReadnixToken", account: "user")
            } else {
                KeychainHelper.shared.delete(service: "ReadnixToken", account: "user")
            }
        }
    }

    @Published var libraryId: String? {
        didSet {
            if let id = libraryId {
                UserDefaults.standard.set(id, forKey: libraryIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: libraryIdKey)
            }
        }
    }
    
    func logout() {
        authToken = nil
        libraryId = nil
    }

    private init() {
        self.authToken = KeychainHelper.shared.read(service: "ReadnixToken", account: "user")
        self.libraryId = UserDefaults.standard.string(forKey: libraryIdKey)
    }

    var isAuthorized: Bool {
        authToken != nil
    }
}
