//
//  WantManager.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import Foundation

class WantManager: ObservableObject {
    @Published var availableWants: [Want] = []
    @Published var currentWant: Want?
    private let service = FirestoreService()
    
    func loadWants(forMood mood: String) {
        Task {
            do {
                let wants = try await service.fetchWants(forMood: mood)
                await MainActor.run {
                    self.availableWants = wants
                    self.selectRandomWant()
                    print("availableWants:", self.availableWants)
                }
            } catch {
                print("Failed to load wants:", error)
            }
        }
    }
    
    func selectRandomWant() {
        guard !availableWants.isEmpty else { currentWant = nil; return }
        currentWant = availableWants.randomElement()
    }
    
    func validateCurrentWant() {
        guard let current = currentWant else { return }
        availableWants.removeAll { $0.id == current.id }
        selectRandomWant()
    }
}
