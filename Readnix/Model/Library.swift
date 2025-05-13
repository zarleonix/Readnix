//
//  Library.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

struct LibraryResponse: Codable {
    let libraries: [Library]
}

struct Library: Codable {
    let id: String // Read Only
    let name: String
    let folders: [Folder]
    let displayOrder: Int
    let icon: String
    let mediaType: String // Read Only
    let provider: String
    let settings: LibrarySettings
    let createdAt: Int // Read Only
    let lastUpdate: Int // Read Only
}

struct Folder: Codable {
    let id: String
    let fullPath: String
    let libraryId: String
    let addedAt: Int
}

struct LibrarySettings: Codable {
    let coverAspectRatio: Int
    let disableWatcher: Bool
    let skipMatchingMediaWithAsin: Bool
    let skipMatchingMediaWithIsbn: Bool
    let autoScanCronExpression: String?
}
