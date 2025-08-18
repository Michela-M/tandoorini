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
            for doc in documents {
                print(doc.data())
            }
            
            var loadedCategories: [MoodCategory] = []

                    for doc in documents {
                        let data = doc.data()
                        guard
                            let name = data["name"] as? String,
                            let icon = data["icon"] as? String,
                            let moodsData = data["moods"] as? [[String: Any]]
                        else {
                            print("⚠️ Invalid document structure for \(doc.documentID)")
                            continue
                        }

                        let moods: [Mood] = moodsData.compactMap { moodDict in
                            guard
                                let moodName = moodDict["name"] as? String,
                                let moodIcon = moodDict["icon"] as? String
                            else { return nil }
                            return Mood(name: moodName, icon: moodIcon)
                        }

                        let category = MoodCategory(name: name, icon: icon, moods: moods)
                        loadedCategories.append(category)
                    }

                    DispatchQueue.main.async {
                        self.categories = loadedCategories
                        print("✅ Categories loaded: \(loadedCategories.count)")
                    }
        }
    }

    
    func saveMood(_ mood: Mood) {
        selectedMood = mood
        // TODO: Integrate with Firestore
        print("💾 Saved mood: \(mood.name)")
    }
}
