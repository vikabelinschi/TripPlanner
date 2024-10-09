//
//  CitySelectorViewModel.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 09.10.2024.
//

import Foundation
import SwiftUI
import Combine

// MARK: - CitySelectorViewModelProtocol
protocol CitySelectorViewModelProtocol: AnyObject, ObservableObject {
    var query: String { get set }
    var selectedCity: String? { get set }
    var showSuggestions: Bool { get set }
    var filteredCities: [String] { get set }

    func selectCity(_ city: String)
    func textFieldFocusChanged(_ isFocused: Bool)

    init(cities: [String])
}


final class CitySelectorViewModel: CitySelectorViewModelProtocol {
    // MARK: - Properties
    @Published var query: String = "" {
        didSet {
            updateFilteredCities(for: query)
            selectedCity = query.isEmpty ? nil : query
        }
    }
    @Published var selectedCity: String?
    @Published var showSuggestions: Bool = false
    @Published var filteredCities: [String] = []

    private var allCities: [String]

    // MARK: - Initialization
    required init(cities: [String]) {
        self.allCities = cities
    }

    // MARK: - Methods
    private func updateFilteredCities(for query: String) {
        if query.isEmpty {
            filteredCities = []
            showSuggestions = false
        } else {
            filteredCities = allCities.filter { $0.localizedCaseInsensitiveContains(query) }
            showSuggestions = !filteredCities.isEmpty
        }
    }

    func selectCity(_ city: String) {
        query = city
        selectedCity = city
        showSuggestions = false
    }

    func textFieldFocusChanged(_ isFocused: Bool) {
        if !isFocused {
            showSuggestions = false
        } else if !query.isEmpty {
            showSuggestions = true
        }
    }
}
