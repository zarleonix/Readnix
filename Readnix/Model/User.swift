//
//  User.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

//struct UserResponse: Codable {
//    let user: User
//}

struct User: Codable {
    let id: String
    let username: String
    let type: String
    let token: String
    let mediaProgress: [MediaProgress]
    let seriesHideFromContinueListening: [String]
    let bookmarks: [AudioBookmark]
    let isActive: Bool
    let isLocked: Bool
    let lastSeen: Int?
    let createdAt: Int
    let permissions: UserPermissions
    let librariesAccessible: [String]
    let itemTagsAccessible: [String]
}

struct UserPermissions: Codable {
    let download: Bool
    let update: Bool
    let delete: Bool
    let upload: Bool
    let accessAllLibraries: Bool
    let accessAllTags: Bool
    let accessExplicitContent: Bool
}

struct MediaProgress: Codable {
    let id: String
    let libraryItemId: String
    let episodeId: String?
    let duration: Float
    let progress: Float
    let currentTime: Float
    let isFinished: Bool
    let hideFromContinueListening: Bool
    let lastUpdate: Int
    let startedAt: Int
    let finishedAt: Int?
}

struct AudioBookmark: Codable {
    let libraryItemId: String
    let title: String
    let time: Int
    let createdAt: Int
}
