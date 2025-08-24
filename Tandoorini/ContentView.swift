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
            // Main content area
            VStack {
                MainLayoutView(currentPage: currentPage, isMenuOpen: $isMenuOpen) {
                    // This is where different page content goes
                    currentPageView
                }
                .disabled(isMenuOpen)

                // Main Content
                WantsView(manager: wantManager, mood: selectedMood)
                Spacer()
                
            }
            .padding(16)
            .disabled(isMenuOpen)
            
            // Side Menu
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
            
            // Overlay to close menu
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen = false
                        }
                    }
            }
            
            VStack {
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
    }
    
    @ViewBuilder
        private var currentPageView: some View {
            switch currentPage {
            case "Home":
                HomePageView()
            default:
                HomePageView()
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
