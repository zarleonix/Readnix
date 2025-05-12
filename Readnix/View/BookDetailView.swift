//
//  BookDetailView.swift
//  Readnix
//
//  Created by zarleonix on 12.05.2025.
// 


import SwiftUI

struct BookDetailView: View {
    let book: Book

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(book.title)
                    .font(.title)
                    .bold()

                if let author = book.author?.name {
                    Text("Автор: \(author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("Длительность: \(formattedDuration(seconds: book.duration))")
                    .font(.subheadline)
                

                if let progress = book.progress?.seconds {
                    Text("Прогресс: \(formattedDuration(seconds: progress))")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

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

    func formattedDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)ч \(minutes)м"
    }
}

//#Preview {
//    BookDetailView()
//}
