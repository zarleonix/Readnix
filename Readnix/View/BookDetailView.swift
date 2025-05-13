//
//  BookDetailView.swift
//  Readnix
//
//  Created by zarleonix on 12.05.2025.
// 


import SwiftUI

struct BookDetailView: View {
    let libraryItem: LibraryItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(libraryItem.media.metadata.title)
                    .font(.title)
                    .bold()

                
                Text("Автор: \(libraryItem.media.metadata.authorName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                

                Text("Длительность: \(formattedDuration(seconds: libraryItem.media.duration!))")
                    .font(.subheadline)
                

//                if let progress = book.progress?.seconds {
//                    Text("Прогресс: \(formattedDuration(seconds: progress))")
//                        .font(.subheadline)
//                        .foregroundColor(.blue)
//                }

                // Кнопки действия — в будущем
                HStack {
                    Button("Начать") {
                        // TODO: обработка начала
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Закладка") {
                        // TODO: обработка
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("О книге")
        .navigationBarTitleDisplayMode(.inline)
    }

    func formattedDuration(seconds: Float) -> String {
        let hours = Int(seconds / 3600)
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)ч \(minutes)м"
    }
}

//#Preview {
//    BookDetailView()
//}
