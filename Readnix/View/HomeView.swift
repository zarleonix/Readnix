//
//  HomeView.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query var items: [LibraryItemLocal] // читает данные, и следит за изменениями
    @Environment(\.modelContext) private var context // позволяет записывать и удалять данные
    
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: Text("Книга: \(item.title)")) {
                    HStack {
                        if let path = item.coverLocalPath, let image = UIImage(contentsOfFile: path) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 60, height: 90)
                                .cornerRadius(6)
                        } else {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 60, height: 90)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            if let author = item.author {
                                Text(author)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Аудиокниги")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Выход") {
                        SessionManager.shared.logout()
                    }
                }
            }
            .refreshable {
                await updateBooksFromServer()
            }
        }
    }
    
    private func updateBooksFromServer() async {
        guard let token = SessionManager.shared.authToken,
              let libraryId = SessionManager.shared.libraryId else { return }
        
        let client = APIClient(serverURL: SessionManager.shared.serverURL ?? "")
        do {
            let books = try await client.getBooks(libraryId: libraryId, token: token)
            await LibraryItemStorage.syncBooks(books, serverURL: client.serverURL, context: context)
        } catch {
            print("Ошибка обновления книг: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    HomeView()
//}
