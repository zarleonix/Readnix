//
//  BookSyncService.swift
//  Readnix
//
//  Created by zarleonix on 14.05.2025.
// 

import Foundation
import SwiftData

struct BookSyncService {
    let context: ModelContext
    let client: APIClient
    let serverURL: String
    let token: String
    let libraryId: String

    func syncBooks() async throws {
        let books = try await client.getBooks(libraryId: libraryId, token: token)

        for book in books {
            let title = book.media.metadata.title
            let author = book.media.metadata.authorName
            let itemId = book.id

            let coverURL = URL(string: "\(serverURL)/api/items/\(itemId)/cover")!
            let savedPath = try await CoverManager.shared.downloadAndSaveCover(from: coverURL, itemId: itemId)

            let model = LibraryItemLocal(id: itemId, title: title, author: author, coverLocalPath: savedPath, duration: nil)
            context.insert(model)
        }
        try context.save()
    }
}
