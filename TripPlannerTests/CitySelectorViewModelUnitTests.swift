//
//  CitySelectorViewModelUnitTests.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 09.10.2024.
//

import Foundation
import XCTest
import Combine
@testable import TripPlanner

// MARK: - CitySelectorViewModelTests
final class CitySelectorViewModelUnitTests: XCTestCase {
    private var viewModel: CitySelectorViewModel!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        let cities = ["New York", "Los Angeles", "San Francisco", "Chicago", "Miami"]
        viewModel = CitySelectorViewModel(cities: cities)
        cancellables = []
    }

    // MARK: - Teardown
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Tests

    // Test that the filtered cities are updated correctly when the query changes
    func testFilteredCitiesUpdatesOnQueryChange() {
        // Given
        let expectation = XCTestExpectation(description: "Filtered cities should update")
        viewModel.$filteredCities
            .dropFirst() // Ignore the initial value
            .sink { filteredCities in
                // Then
                XCTAssertEqual(filteredCities, ["New York"])
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.query = "New"

        wait(for: [expectation], timeout: 1.0)
    }

    // Test that the selected city is set correctly
    func testSelectCityUpdatesQueryAndSelectedCity() {
        // Given
        let expectation = XCTestExpectation(description: "Selected city should update")
        viewModel.$selectedCity
            .dropFirst()
            .sink { selectedCity in
                // Then
                XCTAssertEqual(selectedCity, "Miami")
                XCTAssertEqual(self.viewModel.query, "Miami")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.selectCity("Miami")

        wait(for: [expectation], timeout: 1.0)
    }

    // Test that suggestions are shown or hidden based on text field focus
    func testTextFieldFocusChangesSuggestionVisibility() {
        // Given
        let expectation = XCTestExpectation(description: "Suggestions visibility should update")
        viewModel.query = "Los"
        viewModel.$showSuggestions
            .dropFirst()
            .sink { showSuggestions in
                // Then
                XCTAssertTrue(showSuggestions)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.textFieldFocusChanged(true)

        wait(for: [expectation], timeout: 1.0)
    }

    // Test that suggestions are hidden when the text field loses focus
    func testTextFieldFocusLostHidesSuggestions() {
        // Given
        let expectation = XCTestExpectation(description: "Suggestions should be hidden when focus is lost")
        viewModel.query = "San"
        viewModel.textFieldFocusChanged(true) // Simulate focus gained
        viewModel.$showSuggestions
            .dropFirst() // Drop initial values
            .sink { showSuggestions in
                // Then
                XCTAssertFalse(showSuggestions)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.textFieldFocusChanged(false)

        wait(for: [expectation], timeout: 1.0)
    }
}
