//
//  TripPlannerServiceUnitTests.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import Combine
import XCTest
@testable import TripPlanner

// MARK: - TripPlannerServiceUnitTests
class TripPlannerServiceUnitTests: XCTestCase {
    // MARK: - Properties
    var service: MockTripPlannerService!
    var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        // Given: A mock service instance
        service = MockTripPlannerService()
    }

    override func tearDown() {
        // Cleanup
        service = nil
        cancellables = []
        super.tearDown()
    }

    // MARK: - Tests

    // Test fetching connections from JSON
    func testFetchConnectionsFromJSON() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch connections successfully from JSON")

        // When
        service.fetchConnections()
            .sink(receiveCompletion: { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got failure with error: \(error)")
                }
            }, receiveValue: { connections in
                // Then
                XCTAssertEqual(connections.count, 13)
                XCTAssertEqual(connections.first?.from, "London")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 5.0)
    }
}
