//
//  MoodSelectionView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 17.08.2025.
//

import SwiftUI

struct MoodSelectionView: View {
    @State private var selectedCategory: MoodCategory? = nil
    let categories: [MoodCategory]
    let onClose: () -> Void
    let onSaveMood: (Mood) -> Void

    var body: some View {
        NavigationStack {
            List(categories) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack {
                        Text(category.icon)
                        Text(category.name).font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("How are you feeling?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Root screen shows Skip
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") { onClose() }
                }
            }
            .navigationDestination(item: $selectedCategory) { category in
                MoodSubmoodListView(
                    category: category,
                    onSkip: onClose,                // dismiss without saving
                    onSave: { mood in onSaveMood(mood) } // save then dismiss
                )
            }
        }
    }
}
