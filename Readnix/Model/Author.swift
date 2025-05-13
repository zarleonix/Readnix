//
//  Author.swift
//  Readnix
//
//  Created by zarleonix on 13.05.2025.
// 


import Foundation

struct Author: Identifiable, Codable {
    let id: String
    let asin: String?
    let name: String
    let description: String?
    let imagePath: String?
    let addedAt: Int
    let updatedAt: Int
    let numBooks: Int
}
