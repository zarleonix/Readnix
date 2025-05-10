//
//  APIClient.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import Foundation

class APIClient {
    private let serverURL: String
    private let session = URLSession.shared

    init(serverURL: String) {
        self.serverURL = serverURL
    }

    // Метод для авторизации
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard var baseURL = URL(string: serverURL) else {
            print("Неверный URL сервера")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL сервера"])))
            return
        }
        
        baseURL.appendPathComponent("login")
        print("Попытка входа по адресу: \(baseURL)")

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            print("Отправляемые данные: \(body)")
        } catch {
            print("Ошибка сериализации JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Неизвестный ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неизвестный ответ от сервера"])))
                return
            }

            print("Статус-код: \(httpResponse.statusCode)")

            guard let data = data else {
                print("Пустой ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                return
            }

            let rawResponse = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
            print("Raw ответ от сервера: \(rawResponse)")

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Не удалось декодировать JSON")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать JSON"])))
                    return
                }

                // Ищем токен внутри "user"
                if let user = json["user"] as? [String: Any], let token = user["token"] as? String {
                    print("Успешный вход! Токен: \(token)")
                    completion(.success(token))
                } else {
                    print("Токен не найден в ответе")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Токен не найден в ответе"])))
                }
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription), Ответ: \(rawResponse)")
                completion(.failure(error))
            }
            
        }

        task.resume()
    }

    // Метод для получения списка аудиокниг
    func getBooks(token: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard var baseURL = URL(string: serverURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL сервера"])))
            return
        }

        baseURL.appendPathComponent("api/me/books")

        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неизвестный ответ от сервера"])))
                return
            }

            print("Статус-код: \(httpResponse.statusCode)")

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let bookResponse = try decoder.decode(BookResponse.self, from: data)
                print("Получено книг: \(bookResponse.books.count)")
                completion(.success(bookResponse.books))
            } catch {
                let rawResponse = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
                print("Ошибка парсинга JSON: \(error.localizedDescription), Ответ: \(rawResponse)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getLibraryItems(libraryId: String, token: String, completion: @escaping (Result<[LibraryItem], Error>) -> Void) {
        guard var baseURL = URL(string: serverURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL сервера"])))
            return
        }

        baseURL.appendPathComponent("api/libraries/\(libraryId)/items")

        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Неизвестный ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неизвестный ответ от сервера"])))
                return
            }

            guard httpResponse.statusCode == 200 else {
                let rawResponse = String(data: data ?? Data(), encoding: .utf8) ?? "Не удалось раскодировать"
                print("Сервер вернул ошибку: \(httpResponse.statusCode), Ответ: \(rawResponse)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка загрузки библиотеки"])))
                return
            }

            guard let data = data else {
                print("Пустой ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let booksResponse = try decoder.decode(LibraryItemResponse.self, from: data)
                let items = booksResponse.results
                print("Получено книг: \(items.count)")
                completion(.success(items))
            } catch {
                let rawResponse = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
                print("Ошибка парсинга JSON: \(error.localizedDescription), Ответ: \(rawResponse)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    // получение данных о пользователе
    func fetchUser(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard var baseURL = URL(string: serverURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL сервера"])))
            return
        }

        baseURL.appendPathComponent("api/me")

        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Неизвестный ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неизвестный ответ от сервера"])))
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("Сервер вернул ошибку: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка авторизации"])))
                return
            }

            guard let data = data else {
                print("Пустой ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                print("Получен пользователь: \(user.username)")
                completion(.success(user))
            } catch {
                let rawResponse = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
                print("Ошибка парсинга JSON: \(error.localizedDescription), Ответ: \(rawResponse)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func getLibraries(token: String, completion: @escaping (Result<[Library], Error>) -> Void) {
        guard var baseURL = URL(string: serverURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL сервера"])))
            return
        }

        baseURL.appendPathComponent("api/libraries")

        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Неизвестный ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неизвестный ответ от сервера"])))
                return
            }

            guard httpResponse.statusCode == 200 else {
                let rawResponse = String(data: data ?? Data(), encoding: .utf8) ?? "Не удалось раскодировать"
                print("Сервер вернул ошибку: \(httpResponse.statusCode), Ответ: \(rawResponse)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка получения библиотек"])))
                return
            }

            guard let data = data else {
                print("Пустой ответ от сервера")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let libraryResponse = try decoder.decode(LibraryResponse.self, from: data)
                print("Получено библиотек: \(libraryResponse.libraries.count)")
                completion(.success(libraryResponse.libraries))
            } catch {
                let rawResponse = String(data: data, encoding: .utf8) ?? "Не удалось раскодировать"
                print("Ошибка парсинга JSON: \(error.localizedDescription), Ответ: \(rawResponse)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
