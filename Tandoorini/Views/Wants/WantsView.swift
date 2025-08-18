//
//  WantsView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import Foundation
import SwiftUICore

struct WantsView: View {
    @ObservedObject var manager: WantManager
    let mood: Mood
    let maxVisibleWants = 3
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer() // Push cards to center vertically
            
            // Take up to 3 wants from availableWants
            let wantsToShow = manager.availableWants.prefix(maxVisibleWants)
            
            ForEach(0..<maxVisibleWants, id: \.self) { index in
                if index < wantsToShow.count {
                    let want = wantsToShow[wantsToShow.index(wantsToShow.startIndex, offsetBy: index)]
                    WantCard(want: want) {
                        manager.validateCurrentWant()
                    }
                    .frame(maxWidth: .infinity) // Full width
                    .frame(height: 140) // Card height
                    .padding(.horizontal)
                } else {
                    // Placeholder
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                        .overlay(
                            Text("No want")
                                .foregroundColor(.gray)
                                .font(.headline)
                        )
                        .padding(.horizontal)
                }
            }
            
            Spacer() // Push cards to center vertically
        }
        .navigationTitle("Your Wants")
        .onAppear {
            manager.loadWants(forMood: mood.name)
        }
    }
}
