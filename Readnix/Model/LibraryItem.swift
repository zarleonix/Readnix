//
//  Book.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

// Основная модель ответа
struct LibraryItemsResponse: Codable {
    let results: [LibraryItem]
}

struct LibraryItem: Codable, Identifiable {
    let id: String
    let ino: String
    let oldLibraryItemId: String?
    let libraryId: String
    let folderId: String
    let path: String
    let relPath: String
    let isFile: Bool
    let mtimeMs: Int
    let ctimeMs: Int
    let birthtimeMs: Int
    let addedAt: Int
    let updatedAt: Int
    let isMissing: Bool
    let isInvalid: Bool
    let mediaType: String
    let media: Media
    let numFiles: Int
    let size: Int
}

struct Media: Codable {
    let id: String
    let metadata: MediaMetadata
    let coverPath: String?
    let tags: [String]
    let numTracks: Int?
    let numAudioFiles: Int?
    let numChapters: Int?
    let duration: Float?
    let size: Int
    let ebookFormat: String?
}

struct MediaMetadata: Codable {
    let title: String
    let titleIgnorePrefix: String?
    let subtitle: String?
    let authorName: String
    let authorNameLF: String
    let narratorName: String?
    let seriesName: String?
    let genres: [String]
    let publishedYear: String?
    let publishedDate: String?
    let publisher: String?
    let description: String?
    let isbn: String?
    let asin: String?
    let language: String?
    let explicit: Bool
    let abridged: Bool
}

