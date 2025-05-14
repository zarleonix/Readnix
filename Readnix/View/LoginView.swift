//
//  ContentView.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var serverUrl = ""
    @State private var username = ""
    @State private var password = ""
    @State private var books: [LibraryItem] = []
    @StateObject var session = SessionManager.shared
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.modelContext) private var context

    var body: some View {
        if session.authToken == nil {
            NavigationView {
                Form {
                    Section(header: Text("label_Server")) {
                        TextField("label_serverUrl", text: $serverUrl)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }

                    Section(header: Text("label_login")) {
                        TextField("label_username", text: $username)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Label_Password", text: $password)
                    }

                    Button("login_button") {
                        Task {
                            await login()
                        }
                    }
                }
                .navigationTitle("label_login")
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        } else {
            HomeView()
        }
    }

    func login() async {
        let client = APIClient(serverURL: serverUrl)

        do {
            // 1. Авторизация
            let token = try await client.login(username: username, password: password)
            SessionManager.shared.authToken = token
            SessionManager.shared.serverURL = serverUrl
            
            // 2. Получение библиотек
            let libraries = try await client.getLibraries(token: token)
            guard let firstLibrary = libraries.first else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Библиотеки не найдены"])
            }
            SessionManager.shared.libraryId = firstLibrary.id
            
            // 3. Получение книг
            let books = try await client.getBooks(libraryId: firstLibrary.id, token: token)
            
            await MainActor.run {
                self.books = books
            }
            
            try context.delete(model: LibraryItemLocal.self)
            await LibraryItemStorage.syncBooks(books, serverURL: session.serverURL!, context: context)
            
            // 4. Получение данных пользователя
            let user = try await client.fetchUser(token: token)
            
        } catch {
            await MainActor.run {
                self.alertMessage = "Ошибка: \(error.localizedDescription)"
                self.showingAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
}
