//
//  CitySelectorView.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import SwiftUI

// MARK: - CitySelectorView
struct CitySelectorView: View {

    // MARK: - Properties
    @Binding var selectedCity: String?
    var cities: [String]
    var placeholder: String

    @State private var showSuggestions: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    // MARK: - Body
    var body: some View {
        VStack {

            // MARK: - TextField
            TextField(placeholder, text: Binding(
                get: {
                    selectedCity ?? ""
                },
                set: { newValue in
                    selectedCity = newValue
                    showSuggestions = !newValue.isEmpty
                }
            ))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal)
            .focused($isTextFieldFocused)
            .onChange(of: isTextFieldFocused) {
                if !isTextFieldFocused {
                    showSuggestions = false
                }
            }
            .onTapGesture {
                if !(selectedCity?.isEmpty ?? true) {
                    showSuggestions = true
                }
            }

            // MARK: - Suggestions List
            if showSuggestions {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(cities.filter { $0.localizedCaseInsensitiveContains(selectedCity ?? "") }, id: \.self) { suggestion in
                            Button(action: {
                                selectedCity = suggestion
                                showSuggestions = false
                            }) {
                                Text(suggestion)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(UIColor.systemGray5).opacity(0.4))
                            )
                            .hoverEffect(.highlight)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                .frame(maxHeight: 200)
                .padding(.horizontal)
            }
        }
    }
}
