//
//  FirestoreService.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import FirebaseFirestore


class FirestoreService {
    private let db = Firestore.firestore()
    
    private func getDocuments<T: Decodable>(for query: Query) async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            query.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                let docs = snapshot?.documents.compactMap { try? $0.data(as: T.self) } ?? []
                continuation.resume(returning: docs)
            }
        }
    }
    
    func fetchWants(forMood mood: String) async throws -> [Want] {
        let moodQuery = db.collection("wants").whereField("tags", arrayContains: mood)
        let genericQuery = db.collection("wants").whereField("isGeneric", isEqualTo: true)
        
        async let moodWants: [Want] = getDocuments(for: moodQuery)
        async let genericWants: [Want] = getDocuments(for: genericQuery)
        
        let (moodArr, genericArr) = try await (moodWants, genericWants)
        
        // Deduplicate by id
        var dict: [String: Want] = [:]
        for w in moodArr + genericArr {
            if let id = w.id {
                dict[id] = w
            } else {
                dict[UUID().uuidString] = w
            }
        }
        return Array(dict.values)
    }
}
