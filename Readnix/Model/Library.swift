//
//  Library.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

// MARK: - LibraryResponse
struct LibraryResponse: Codable {
    let libraries: [Library]
}

// MARK: - Library
struct Library: Codable {
    let id: String
    let name: String
    let folders: [Folder]
    let displayOrder: Int
    let mediaType: String
    let provider: String
    // другие поля можно добавлять по мере необходимости
}

// MARK: - Folder
struct Folder: Codable {
    let id: String
    let fullPath: String
    let libraryId: String
    let addedAt: Int64
}
