//
//  CitySelectorView.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import SwiftUI

// MARK: - CitySelectorView
struct CitySelectorView<CitySelectorViewModel>: View where CitySelectorViewModel: CitySelectorViewModelProtocol{

    // MARK: - Properties
    @Binding var selectedCity: String?
    var placeholder: String
    var cities: [String]

    @StateObject private var viewModel: CitySelectorViewModel
    @FocusState private var isTextFieldFocused: Bool

    // MARK: - Initialization
    init(selectedCity: Binding<String?>, placeholder: String, cities: [String]) {
        self._selectedCity = selectedCity
        self.placeholder = placeholder
        self.cities = cities
        _viewModel = StateObject(wrappedValue: CitySelectorViewModel(cities: cities))
    }

    // MARK: - Body
    var body: some View {
        VStack {
            textFieldView
            if viewModel.showSuggestions {
                suggestionsListView
            }
        }
    }

    // MARK: - Subviews
    private var textFieldView: some View {
        TextField(placeholder, text: $viewModel.query)
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
                viewModel.textFieldFocusChanged(isTextFieldFocused)
            }
            .onChange(of: viewModel.selectedCity) {
                selectedCity = viewModel.selectedCity
            }
    }

    private var suggestionsListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.filteredCities, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.selectCity(suggestion)
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
