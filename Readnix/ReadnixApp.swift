//
//  ReadnixApp.swift
//  Readnix
//
//  Created by zarleonix on 10.05.2025.
//

import SwiftUI

@main
struct ReadnixApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(for: LibraryItemLocal.self)
    }
}
