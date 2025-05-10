//
//  SessionManager.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

#warning("Позже переделать на Keychain")
class SessionManager {
    static let shared = SessionManager()

    private let defaults = UserDefaults.standard
    private let kAuthToken = "auth_token"
    private let kLibraryId = "library_id"

    var authToken: String? {
        get { defaults.string(forKey: kAuthToken) }
        set { defaults.set(newValue, forKey: kAuthToken) }
    }

    var libraryId: String? {
        get { defaults.string(forKey: kLibraryId) }
        set { defaults.set(newValue, forKey: kLibraryId) }
    }

    var isUserLoggedIn: Bool {
        return authToken != nil && libraryId != nil
    }

    func clearSession() {
        authToken = nil
        libraryId = nil
    }
}
