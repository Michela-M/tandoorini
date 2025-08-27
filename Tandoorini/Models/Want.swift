//
//  Want.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import Foundation
import FirebaseFirestore

struct Want: Identifiable, Codable {
    var id: String?
    let name: String
    let description: String?
    let moods: [String]
    let xp: Int
    let coin: Int
}
