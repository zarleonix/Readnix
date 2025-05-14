//
//  LibraryItemModel.swift
//  Readnix
//
//  Created by zarleonix on 14.05.2025.
// 

import Foundation
import SwiftUI
import SwiftData

@Model
class LibraryItemLocal {
    @Attribute(.unique) var id: String
    var title: String
    var author: String?
    var coverLocalPath: String? // Локальный путь до обложки
    var duration: Float?

    init(id: String, title: String, author: String?, coverLocalPath: String?, duration: Float?) {
        self.id = id
        self.title = title
        self.author = author
        self.coverLocalPath = coverLocalPath
        self.duration = duration
    }
}

struct CoverManager {
    static let shared = CoverManager()
    private let directoryName = "BookCovers"

    // Путь к директории с обложками
    private var coversDirectoryURL: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(directoryName)
    }

    // Сохраняет обложку по URL, возвращает путь к сохранённому файлу
    func downloadAndSaveCover(from url: URL, itemId: String) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)

        guard let folderURL = coversDirectoryURL else {
            throw NSError(domain: "CoverManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить путь к папке обложек"])
        }

        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)

        let fileURL = folderURL.appendingPathComponent("\(itemId).jpg")
        try data.write(to: fileURL)

        return fileURL.path
    }

    // Загружает изображение по локальному пути
    func loadImage(from path: String) -> Image {
        if let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "book.closed")
        }
    }
}

//@ModelActor
actor LibraryItemStorage {
    static func syncBooks(_ books: [LibraryItem], serverURL: String, context: ModelContext) async {
        for book in books {
            let id = book.id
            let title = book.media.metadata.title
            let author = book.media.metadata.authorName
            let coverURL = URL(string: "\(serverURL)/api/items/\(id)/cover")

            var localCoverPath: String? = nil
            if let url = coverURL {
                do {
                    let data = try await downloadCover(from: url)
                    localCoverPath = try saveCoverToFile(data: data, id: id)
                } catch {
                    print("Ошибка загрузки обложки: \(error.localizedDescription)")
                }
            }

            let fetchDescriptor = FetchDescriptor<LibraryItemLocal>(
                predicate: #Predicate<LibraryItemLocal> { $0.id == id }
            )

            if let existing = try? context.fetch(fetchDescriptor).first {
                existing.title = title
                existing.author = author
                existing.coverLocalPath = localCoverPath
//                existing.duration = book.media.duration ?? 0
            } else {
                let newItem = LibraryItemLocal(
                    id: id,
                    title: title,
                    author: author,
                    coverLocalPath: localCoverPath,
                    duration: book.media.duration
                )
                context.insert(newItem)
            }
        }
        try? context.save()
    }

    private static func downloadCover(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    private static func saveCoverToFile(data: Data, id: String) throws -> String {
        let filename = "\(id).jpg"
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        try data.write(to: url)
        return url.path
    }
}
