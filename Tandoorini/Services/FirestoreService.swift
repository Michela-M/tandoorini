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
    
    func fetchWants(forMood moodName: String) async throws -> [Want] {
        let query = db.collection("wants")
        let snapshot = try await query.getDocuments()
        var wants: [Want] = []
        
        for doc in snapshot.documents {
            let data = doc.data()

            guard let name = data["name"] as? String else {
                print("⚠️ Skipping want without a name: \(doc.documentID)")
                continue
            }

            let description = data["description"] as? String
            let xp = data["xp"] as? Int ?? 10
            let coin = data["coin"] as? Int ?? 5
            let moodRefs = data["mood"] as? [DocumentReference] ?? []
                        
            // Fetch mood names from references
            let moodNames: [String] = try await withThrowingTaskGroup(of: String?.self) { group in
                for ref in moodRefs {
                    group.addTask {
                        let moodDoc = try await ref.getDocument()
                        return moodDoc.data()?["name"] as? String
                    }
                }

                var names: [String] = []
                for try await name in group {
                    if let name = name {
                        names.append(name)
                    }
                }
                return names
            }

            // Filter wants that match the given mood name
            if moodNames.contains(moodName) {
                let want = Want(
                    id: doc.documentID,
                    name: name,
                    description: description,
                    moods: moodNames,
                    xp: xp,
                    coin: coin
                )
                wants.append(want)
            }
        }

        return wants
    }

}
