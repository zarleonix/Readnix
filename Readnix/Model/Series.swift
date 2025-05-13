//
//  Series.swift
//  Readnix
//
//  Created by zarleonix on 13.05.2025.
// 


import Foundation

struct Series: Identifiable, Codable {
    let id: String
    let name: String
    let description: String?
    let addedAt: Int
    let updatedAt: Int
}
