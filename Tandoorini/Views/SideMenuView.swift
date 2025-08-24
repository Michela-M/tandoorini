//
//  SideMenuView.swift
//  Tandoorini
//
//  Created by Michela Mullins on 24.08.2025.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @Binding var currentPage: String
    
    let menuItems = [
        ("house.fill", "Home"),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Menu Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .font(.headline)
                        Text("john@example.com")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 8)
                
                Divider()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Menu Items
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(menuItems, id: \.1) { icon, title in
                        Button(action: {
                            currentPage = title
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMenuOpen = false
                            }
                        }) {
                            HStack {
                                Image(systemName: icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(currentPage == title ? .blue : .primary)
                                    .frame(width: 25)
                                
                                Text(title)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(currentPage == title ? .blue : .primary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(
                                currentPage == title ?
                                Color.blue.opacity(0.1) : Color.clear
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Spacer()
            
            // Menu Footer
            VStack {
                Divider()
                Button(action: {
                    // Handle logout
                    print("Logout tapped")
                }) {
                    HStack {
                        Image(systemName: "power")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .frame(width: 25)
                        
                        Text("Logout")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 280)
        .frame(maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(0)
        .shadow(radius: 10)
    }
}
