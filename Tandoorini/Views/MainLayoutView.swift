//
//  MainLayoutView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 24.08.2025.
//

import SwiftUI

struct MainLayoutView<Content: View>: View {
    let currentPage: String
    @Binding var isMenuOpen: Bool
    let content: Content
    
    init(currentPage: String, isMenuOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.currentPage = currentPage
        self._isMenuOpen = isMenuOpen
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                // Hamburger Menu Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen.toggle()
                    }
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                // Page Title
                Text(currentPage)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 8)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.gray.opacity(0.3)),
                alignment: .bottom
            )
        }
    }
}
