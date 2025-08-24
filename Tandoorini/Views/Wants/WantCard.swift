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
        ZStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(want.title)
                    .font(.headline)
                
                if let description = want.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 1)
            )
            .onTapGesture {
                withAnimation {
                    showCheck = true
                }
                onValidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showCheck = false
                    }
                }
            }

            if showCheck {
                Text("✅")
                    .font(.system(size: 60))
                    .transition(.scale)
            }
        }
    }
}

