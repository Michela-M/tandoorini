//
//  MoodView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 27.08.2025.
//

import SwiftUI

public struct MoodView: View {
    let mood: Mood?
    private let relativeDateFormatter = RelativeDateTimeFormatter()

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let mood = mood {
                    Text(mood.name)
                        .font(.headline)
                    
                    if let savedDate = mood.savedAt {
                        if Date().timeIntervalSince(savedDate) < 60 {
                            Text("Just now")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text(relativeDateFormatter.localizedString(for: savedDate, relativeTo: Date()))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let mood = mood {
                Text(mood.icon)
            }
            else {
                Text("😀")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black, lineWidth: 1)
        )
    }
    
    private var savedDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium   // e.g. Aug 27, 2025
        formatter.timeStyle = .short    // e.g. 3:58 PM
        formatter.locale = Locale.current
        return formatter
    }
}
