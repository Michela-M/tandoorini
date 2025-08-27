//
//  HomePageView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 24.08.2025.
//

import SwiftUI

struct HomePageView: View {
    @ObservedObject var moodVM: MoodSelectionViewModel
    @ObservedObject var wantManager: WantManager

    @Binding var showMoodPanel: Bool
    @Binding var selectedMood: Mood?

    var body: some View {
        
        ZStack {
            VStack{
                MoodView(mood: selectedMood)
                WantsView(manager: wantManager, mood: selectedMood)
                Spacer()
            }
        }
        .padding(16)
    }
}
