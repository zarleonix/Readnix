//
//  HomeView.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import SwiftUI

struct HomeView: View {
    let libraryItem: [LibraryItem]
    let token: String
    let serverUrl: String
    
    var body: some View {
        NavigationView {
            List(libraryItem) { libraryItem in
                NavigationLink(destination: Text("Книга: \(libraryItem.media.metadata.title ?? "Без названия")")) {
                    VStack(alignment: .leading) {
                        Text(libraryItem.media.metadata.title)
                            .font(.headline)
                       
                        Text(libraryItem.media.metadata.authorName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
        }
    }
}

//#Preview {
//    HomeView()
//}
