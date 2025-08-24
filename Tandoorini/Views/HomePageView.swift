//
//  HomePageView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 24.08.2025.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Welcome to Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                VStack(spacing: 15) {
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
