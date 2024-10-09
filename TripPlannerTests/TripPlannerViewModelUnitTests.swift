//
//  TripPlannerViewModelUnitTests.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import XCTest
import Combine
@testable import TripPlanner

// MARK: - TripPlannerViewModelTests
final class TripPlannerViewModelTests: XCTestCase {
    private var viewModel: TripPlannerViewModel!
    private var mockService: MockTripPlannerService!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockService = MockTripPlannerService()
        viewModel = TripPlannerViewModel(service: mockService)
        cancellables = []
    }

    // MARK: - Teardown
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Tests

    // Test that cities are loaded correctly
    func testGetCitiesSuccess() {
        // Given
        mockService.shouldReturnError = false
        let expectation = XCTestExpectation(description: "Cities should be loaded")

        viewModel.$allCities
            .dropFirst()
            .sink { allCities in
                XCTAssertEqual(allCities.count, 13)
                XCTAssertFalse(allCities.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.getCities()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // Test that an error is handled correctly when fetching cities
    func testGetCitiesFailure() {
        // Given
        mockService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Error message should be set")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.getCities()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // Test that the cheapest route is found correctly
    func testFindCheapestRouteSuccess() {
        // Given
        mockService.shouldReturnError = false
        viewModel.getCities()
        viewModel.fromCity = "London"
        viewModel.toCity = "Tokyo"

        let expectation = XCTestExpectation(description: "Cheapest route should be found")
        let priceExpectation = XCTestExpectation(description: "Cheapest price should be set")

        viewModel.$cheapestRoute
            .dropFirst()
            .sink { route in
                XCTAssertEqual(route.count, 10)
                XCTAssertEqual(route[0].from, "London")
                XCTAssertEqual(route[1].to, "Berlin")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$totalPrice
            .dropFirst()
            .sink { price in
                XCTAssertEqual(price, 2400.00)
                priceExpectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.findCheapestRoute()

        // Then
        wait(for: [expectation, priceExpectation], timeout: 1.0)
    }

    // Test that no route is available when there are no connections
    func testFindCheapestRouteFailure() {
        // Given
        viewModel.getCities()
        viewModel.fromCity = "New York"
        viewModel.toCity = "Miami"
        mockService.shouldReturnError = true

        let expectation = XCTestExpectation(description: "No route should be available")

        viewModel.$noRouteAvailable
            .dropFirst()
            .sink { noRouteAvailable in
                XCTAssertTrue(noRouteAvailable)
                XCTAssertEqual(self.viewModel.cheapestRoute.count, 0)
                XCTAssertEqual(self.viewModel.totalPrice, 0.0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.findCheapestRoute()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    // Test canFindCheapestRoute when conditions are met
    func testCanFindCheapestRoute() {
        // Given
        viewModel.fromCity = "New York"
        viewModel.toCity = "Los Angeles"
        viewModel.allCities = ["New York", "Los Angeles", "Chicago"]

        // Then
        XCTAssertTrue(viewModel.canFindCheapestRoute)
    }

    // Test canFindCheapestRoute when conditions are not met
    func testCanFindCheapestRouteFails() {
        // Given
        viewModel.fromCity = "New York"
        viewModel.toCity = "Miami"
        viewModel.allCities = ["New York", "Los Angeles", "Chicago"]

        // Then
        XCTAssertFalse(viewModel.canFindCheapestRoute)
    }
}
