//
//  Book.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

// Основная модель ответа
struct BookResponse: Codable {
    let books: [Book]
}

// Модель книги
struct Book: Identifiable, Codable {
    let id: String       // _id
    let title: String
    let author: Author?
    let duration: Int
    let progress: Progress?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case author
        case duration
        case progress
    }
}

// Автор
struct Author: Codable {
    let name: String?
}

// Прогресс
struct Progress: Codable {
    let seconds: Int?
    let isFinished: Bool?
}

// MARK: - модели от ChatGPT
struct LibraryItemResponse: Codable {
    let results: [LibraryItem]
}

struct LibraryItem: Codable, Identifiable {
    let id: String
    let ino: String?
    let oldLibraryItemId: String?
    let libraryId: String
    let folderId: String
    let path: String
    let relPath: String
    let isFile: Bool
    let mtimeMs: Int64
    let ctimeMs: Int64
    let birthtimeMs: Int64
    let addedAt: Int64
    let updatedAt: Int64
    let isMissing: Bool
    let isInvalid: Bool
    let mediaType: String
    let media: Media?
    let numFiles: Int
    let size: Int64
}

// информация о книге/аудиокниге
struct Media: Codable {
    let id: String
    let metadata: Metadata
    let coverPath: String?
    let tags: [String]
    let numTracks: Int
    let numAudioFiles: Int
    let numChapters: Int
    let duration: Double
    let size: Int64
    let ebookFormat: String?
}

// метаданные книги
struct Metadata: Codable {
    let title: String
    let titleIgnorePrefix: String?
    let subtitle: String?
    let authorName: String?
    let authorNameLF: String?
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
