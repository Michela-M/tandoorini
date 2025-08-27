//
//  MoodSelectionViewModel.swift
//  Tandoorini
//
//  Created by Michela Mullins on 17.08.2025.
//

import Foundation
import FirebaseFirestore

class MoodSelectionViewModel: ObservableObject {
    @Published var categories: [MoodCategory] = []
    @Published var selectedMood: Mood? = nil
    
    private var db = Firestore.firestore()
    
    init() {
            loadCategories()
        }
    
    func loadCategories() {
        db.collection("moodCategories").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error loading categories: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("⚠️ No documents found")
                return
            }

            print("📄 Documents found: \(documents.count)")
            var loadedCategories: [MoodCategory] = []
            let dispatchGroup = DispatchGroup()

            for doc in documents {
                let data = doc.data()
                guard
                    let name = data["name"] as? String,
                    let icon = data["icon"] as? String,
                    let moodRefs = data["moods"] as? [DocumentReference]
                else {
                    print("⚠️ Invalid document structure for \(doc.documentID)")
                    continue
                }

                var moods: [Mood] = []

                for moodRef in moodRefs {
                    dispatchGroup.enter()
                    moodRef.getDocument { moodSnapshot, error in
                        defer { dispatchGroup.leave() }

                        guard let moodData = moodSnapshot?.data(),
                              let moodName = moodData["name"] as? String else {
                            print("⚠️ Failed to load mood from reference: \(moodRef.path)")
                            return
                        }

                        let moodIcon = moodData["icon"] as? String ?? icon
                        moods.append(Mood(name: moodName, icon: moodIcon))
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    let category = MoodCategory(name: name, icon: icon, moods: moods)
                    loadedCategories.append(category)

                    // Update UI once all categories are processed
                    if loadedCategories.count == documents.count {
                        self.categories = loadedCategories
                        print("✅ Categories loaded: \(loadedCategories.count)")
                    }
                }
            }
        }
    }
    
    func saveMood(_ mood: Mood) {
        print("AAAAAAAAA")
        var moodToSave = mood
        moodToSave.savedAt = Date()
        selectedMood = moodToSave

        // TODO: Integrate with Firestore
        print("💾 Saved mood: \(moodToSave.name) at \(moodToSave.savedAt!)")
    }
}
