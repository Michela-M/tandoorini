//
//  WantCard.swift
//  Tandoorini
//
//  Created by Michela Mullins on 18.08.2025.
//

import SwiftUI

struct WantCard: View {
    let want: Want
    let onValidate: () -> Void
    @State private var showCheck = false

    var body: some View {
        VStack(spacing: 16) {
            Text(want.icon ?? "🎯")
                .font(.largeTitle)
            
            Text(want.title)
                .font(.headline)
            
            Button(action: {
                withAnimation {
                    showCheck = true
                }
                onValidate()
                
                // hide check after short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showCheck = false
                    }
                }
            }) {
                Text("Validate")
                    .font(.subheadline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
        .overlay(
            Group {
                if showCheck {
                    Text("✅")
                        .font(.system(size: 60))
                        .transition(.scale)
                }
            }
        )
        .shadow(radius: 4)
    }
}
