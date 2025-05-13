//
//  APIClient.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

/// Клиент для выполнения сетевых запросов к серверу Audiobookshelf.
/// Содержит методы авторизации, получения библиотек, книг и информации о пользователе.
/// Использует URLSession и JSONDecoder.

class APIClient {
    private let serverURL: String
    private let session = URLSession.shared
    
    init(serverURL: String) {
        self.serverURL = serverURL
    }
    
    /// Метод для авторизации
    /// Отправляет POST-запрос на /login для авторизации пользователя.
    /// При успешном входе возвращает JSON с токеном (и, возможно, user-объектом).
    /// В случае ошибки — вызывает completion с ошибкой.
    
    func login(username: String, password: String) async throws -> String {
        guard var url = URL(string: serverURL) else {
            throw URLError(.badURL)
        }
        
        url.appendPathComponent("login")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let raw = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
            throw URLError(.badServerResponse)
        }
        
        let raw = String(data: data, encoding: .utf8) ?? ""
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        if let user = json?["user"] as? [String: Any],
           let token = user["token"] as? String {
            return token
        } else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token not found in response"])
        }
    }
    
    /// Получает список книг из выбранной библиотеки по её ID.
    /// Требует авторизационный токен (Bearer).
    /// Возвращает массив Book или ошибку.
    
    func getBooks(libraryId: String, token: String) async throws -> [LibraryItem] {
        guard var url = URL(string: serverURL) else {
            throw URLError(.badURL)
        }
        
        url.appendPathComponent("api/libraries/\(libraryId)/items")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let raw = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(LibraryItemsResponse.self, from: data)
            return decoded.results
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
            throw error
        }
    }
    
    func fetchUser(token: String) async throws -> User {
        guard var baseURL = URL(string: serverURL) else {
            throw URLError(.badURL)
        }
        
        baseURL.appendPathComponent("api/me")
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неизвестный ответ от сервера"])
        }
        
        guard httpResponse.statusCode == 200 else {
            let raw = String(data: data, encoding: .utf8) ?? "Невозможно раскодировать"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка авторизации"])
        }
        
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            let rawResponse = String(data: data, encoding: .utf8) ?? "Невозможно раскодировать"
            throw error
        }
    }
    
    func getLibraries(token: String) async throws -> [Library] {
        guard var url = URL(string: serverURL) else {
            throw URLError(.badURL)
        }
        
        url.appendPathComponent("api/libraries")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let raw = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(LibraryResponse.self, from: data)
            return decoded.libraries
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
            throw error
        }
    }
}
