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
    @State private var selectedMood: Mood? = nil

    @State private var isMenuOpen = false
    @State private var currentPage = "Home"

    var body: some View {
        ZStack {
            VStack {
                MainLayoutView(currentPage: currentPage, isMenuOpen: $isMenuOpen) {
                    currentPageView
                }
                .disabled(isMenuOpen)
            }
            .disabled(isMenuOpen)
            
            HStack {
                if isMenuOpen {
                    SideMenuView(
                        isMenuOpen: $isMenuOpen,
                        currentPage: $currentPage
                    )
                    .transition(.move(edge: .leading))
                }
                Spacer()
            }
            
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen = false
                        }
                    }
            }
            
            if showMoodPanel {
                MoodSelectionView(
                    categories: moodVM.categories,
                    onClose: {
                        withAnimation(.spring()) {
                            showMoodPanel = false
                        }
                    },
                    onSaveMood: { mood in
                        var moodToSave = mood
                        moodToSave.savedAt = Date()
                        selectedMood = moodToSave
                        
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
    }

    @ViewBuilder
    private var currentPageView: some View {
        switch currentPage {
        case "Home":
            HomePageView(
                moodVM: moodVM,
                wantManager: wantManager,
                showMoodPanel: $showMoodPanel,
                selectedMood: $selectedMood
            )
        default:
            Text("Page not found")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
