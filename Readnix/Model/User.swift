//
//  User.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

// MARK: - User Response
struct UserResponse: Codable {
    let user: User
    let userDefaultLibraryId: String
}

// MARK: - User
struct User: Codable {
    let id: String
    let username: String
    let email: String?
    let type: String
    let token: String // Не стоит хранить токен здесь — лучше передавать отдельно
    let mediaProgress: [MediaProgress]?
    let isActive: Bool
    let isLocked: Bool
    let permissions: Permissions
    let librariesAccessible: [String]
    let hasOpenIDLink: Bool
    // ... другие поля можно добавлять по мере необходимости
}

// MARK: - MediaProgress
struct MediaProgress: Codable {
    let id: String
//    let userId: String
    let libraryItemId: String
    let mediaItemId: String
    let mediaItemType: String
    let duration: Double
    let progress: Double
    let isFinished: Bool
    let currentTime: Double
}

// MARK: - Permissions
struct Permissions: Codable {
    let download: Bool
    let update: Bool
    let delete: Bool
    let upload: Bool
    let createEreader: Bool
    let accessAllLibraries: Bool
    let accessAllTags: Bool
    let accessExplicitContent: Bool
    let selectedTagsNotAccessible: Bool
}
