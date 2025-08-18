//
//  MoodSubmoodListView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 17.08.2025.
//

import SwiftUI

struct MoodSubmoodListView: View {
    let category: MoodCategory
    @State private var selectedMood: Mood? = nil
    
    var body: some View {
        List(category.moods) { mood in
            HStack {
                Text(mood.icon)
                Text(mood.name)
                Spacer()
                if selectedMood == mood {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedMood = mood
            }
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    print("✅ Selected mood: \(selectedMood?.name ?? "None")")
                    // TODO: Save to Firestore or local state
                }
                .disabled(selectedMood == nil)
            }
        }
    }
}
