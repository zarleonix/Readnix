//
//  ContentView.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var serverUrl = ""
    @State private var username = ""
    @State private var password = ""
    @State private var books: [LibraryItem] = []
    @StateObject var session = SessionManager.shared
    @State private var showingAlert = false
    @State private var alertMessage = ""

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
                        login()
                    }
                }
                .navigationTitle("label_login")
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        } else {
            HomeView(libraryItem: books, token: session.authToken!, serverUrl: serverUrl)
        }
    }

    func login() {
        let client = APIClient(serverURL: serverUrl)

        client.login(username: username, password: password) { result in
            switch result {
            case .success(let token):
                SessionManager.shared.authToken = token
                client.getLibraries(token: token) { result in
                    switch result {
                    case .success(let libraries):
                        if let firstLibrary = libraries.first {
                            SessionManager.shared.libraryId = firstLibrary.id
                            client.getBooks(libraryId: firstLibrary.id, token: token) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let books):
                                        self.books = books
                                    case .failure(let error):
                                        self.alertMessage = "Ошибка загрузки: \(error.localizedDescription)"
                                        self.showingAlert = true
                                    }
                                }
                            }
                        } else {
                            self.alertMessage = "Библиотеки не найдены"
                            self.showingAlert = true
                        }
                    case .failure(let error):
                        self.alertMessage = "Ошибка загрузки библиотек: \(error.localizedDescription)"
                        self.showingAlert = true
                    }
                }
            case .failure(let error):
                self.alertMessage = "Ошибка входа: \(error.localizedDescription)"
                self.showingAlert = true
            }
        }
    }
}

#Preview {
    ContentView()
}
