//
//  HomeView.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import SwiftUI

struct HomeView: View {
    let books: [LibraryItem]
    let token: String
    let serverUrl: String
    
    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: Text("Книга: \(book.media?.metadata.title ?? "Без названия")")) {
                    VStack(alignment: .leading) {
                        Text(book.media?.metadata.title ?? "Без названия")
                            .font(.headline)
                        if let author = book.media?.metadata.authorName {
                            Text(author)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Аудиокниги")
        }
    }
}

//#Preview {
//    HomeView()
//}
