//
//  Want.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import Foundation
import FirebaseFirestore

struct Want: Identifiable, Codable {
    @DocumentID var id: String?   // <- gets Firestore document ID
    var title: String
    var description: String?
    var tags: [String]
    var isGeneric: Bool
    var icon: String?
    var difficulty: Int?
}
