//
//  ContentView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 23.07.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var moodVM = MoodSelectionViewModel()
    @StateObject private var wantManager = WantManager()

    @State private var showMoodPanel = true
    @State private var selectedMood: Mood? = nil   // NEW

    var body: some View {
        ZStack {
            if let mood = selectedMood {
                // Show WantsView if mood is selected
                WantsView(manager: wantManager, mood: mood)
            } else {
                Text("Main App Content Here")
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack {
                Spacer()
                if showMoodPanel {
                    MoodSelectionView(
                        categories: moodVM.categories,
                        onClose: {
                            withAnimation(.spring()) {
                                showMoodPanel = false
                            }
                            print("aaaaaa")
                        },
                        onSaveMood: { mood in
                            // Save mood + load wants
                            selectedMood = mood
                            wantManager.loadWants(forMood: mood.name)

                            withAnimation(.spring()) {
                                showMoodPanel = false
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.9)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
