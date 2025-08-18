//
//  MoodSubmoodListView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 17.08.2025.
//

import SwiftUI

struct MoodSubmoodListView: View {
    let category: MoodCategory
    let onSkip: () -> Void
    let onSave: (Mood) -> Void

    @State private var selectedMood: Mood? = nil

    var body: some View {
        List(category.moods) { mood in
            HStack {
                Text(mood.icon)
                Text(mood.name)
                Spacer()
                if selectedMood?.id == mood.id {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { selectedMood = mood }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let mood = selectedMood {
                    Button("Save") { onSave(mood)
                        print("✅ Selected mood: \(selectedMood?.name ?? "None")")}   // save & close (parent wraps in animation)
                } else {
                    Button("Skip") { onSkip() }       // close without saving
                }
            }
        }
    }
}

