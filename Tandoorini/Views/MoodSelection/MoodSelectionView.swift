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
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("How are you feeling?")
                    .font(.title2)
                    .padding(.top, 16)
                
                List(categories) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack {
                            Text(category.icon)
                            Text(category.name)
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationDestination(item: $selectedCategory) { category in
                MoodSubmoodListView(category: category)
            }
        }
    }
}
