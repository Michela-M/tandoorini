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
            // Title
            Text("Wants")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
            

            // Wants or placeholders
            let wantsToShow: Array<Want> = {
                if mood != nil {
                    return Array(manager.availableWants.prefix(maxVisibleWants))
                } else {
                    return []
                }
            }()
            
            ForEach(0..<maxVisibleWants, id: \.self) { index in
                if index < wantsToShow.count {
                    let want = wantsToShow[wantsToShow.index(wantsToShow.startIndex, offsetBy: index)]
                    WantCard(want: want) {
                        manager.validateCurrentWant()
                    }
                        .frame(maxWidth: .infinity)
                } else {
                    // Hug-content placeholder
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
