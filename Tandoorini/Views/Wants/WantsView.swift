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
    let mood: Mood?
    let maxVisibleWants = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Wants")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)

            // Wants or placeholders
            ForEach(0..<maxVisibleWants, id: \.self) { index in
                if index < manager.displayedWants.count {
                    let want = manager.displayedWants[index]
                    WantCard(want: want) {
                        manager.validateWant(want)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    // Placeholder
                    HStack {
                        Text("No want")
                            .font(.headline)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black, lineWidth: 1)
        )
        .onAppear {
            if let mood = mood {
                manager.loadWants(forMood: mood.name)
            }
        }

    }
}
