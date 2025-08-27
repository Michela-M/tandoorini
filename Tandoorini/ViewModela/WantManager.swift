//
//  WantManager.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import Foundation

class WantManager: ObservableObject {
    @Published var displayedWants: [Want] = []
    private var moodWants: [Want] = []
    private var genericWants: [Want] = []
    private var completedWants: [Want] = []
    private let service = FirestoreService()
    
    func loadWants(forMood mood: String) {
        Task {
            do {
                let moodList = try await service.fetchWants(forMood: mood)
                let genericList = try await service.fetchWants(forMood: "Neutral")
                
                await MainActor.run {
                    self.moodWants = moodList.shuffled()
                    self.genericWants = genericList.shuffled()
                    self.completedWants = []
                    self.displayedWants = generateInitialWants()
                }
            } catch {
                print("❌ Failed to load wants:", error)
            }
        }
    }
    
    private func generateInitialWants() -> [Want] {
        var result: [Want] = []
        
        while result.count < 3 {
            let useGeneric = Int.random(in: 0...4) == 0
            let source = useGeneric ? genericWants : moodWants
            
            if let next = source.first {
                result.append(next)
                if useGeneric {
                    genericWants.removeFirst()
                } else {
                    moodWants.removeFirst()
                }
            } else if let fallback = (moodWants + genericWants).first {
                result.append(fallback)
                moodWants.removeAll { $0.id == fallback.id }
                genericWants.removeAll { $0.id == fallback.id }
            } else {
                break
            }
        }
        
        return result
    }
    
    func validateWant(_ want: Want) {
        guard let index = displayedWants.firstIndex(where: { $0.id == want.id }) else { return }

        displayedWants.remove(at: index)
        completedWants.append(want)

        // Recycle if needed
        if moodWants.isEmpty && genericWants.isEmpty {
            let recycled = completedWants.shuffled()
            moodWants = recycled.filter { !$0.moods.isEmpty }
            genericWants = recycled.filter { $0.moods.isEmpty }
            completedWants = []
        }

        // Choose a new want that isn't already displayed
        let useGeneric = Int.random(in: 0...4) == 0
        let source = useGeneric ? genericWants : moodWants

        if let next = source.first(where: { newWant in
            !displayedWants.contains(where: { $0.id == newWant.id })
        }) {
            displayedWants.insert(next, at: index)
            if useGeneric {
                genericWants.removeAll { $0.id == next.id }
            } else {
                moodWants.removeAll { $0.id == next.id }
            }
        } else {
            // Fallback: pick any completed want not currently displayed
            let fallback = (completedWants + moodWants + genericWants)
                .shuffled()
                .first(where: { _ in !displayedWants.contains(where: { $0.id == $0.id }) })

            if let fallback = fallback {
                displayedWants.insert(fallback, at: index)
                moodWants.removeAll { $0.id == fallback.id }
                genericWants.removeAll { $0.id == fallback.id }
            } else {
                // Final fallback: insert a neutral placeholder
                let placeholder = Want(name: "Take a breath", description: "No tasks available, just relax.", moods: [], xp: 0, coin: 0)
                displayedWants.insert(placeholder, at: index)
            }
        }
    }

}
