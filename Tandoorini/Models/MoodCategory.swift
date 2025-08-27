//
//  MoodCategory.swift
//  Tandoorini
//
//  Created by Michela Mullins on 17.08.2025.
//

import Foundation

struct Mood: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let icon: String
    var savedAt: Date? = nil
}

struct MoodCategory: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let icon: String
    let moods: [Mood]
}
