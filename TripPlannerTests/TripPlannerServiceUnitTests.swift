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


class TripPlannerServiceUnitTests: XCTestCase {
    var service: MockTripPlannerService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        service = MockTripPlannerService()
    }

    override func tearDown() {
        service = nil
        cancellables = []
        super.tearDown()
    }

    func testFetchConnectionsFromJSON() {
        let expectation = XCTestExpectation(description: "Fetch connections successfully from JSON")

        service.fetchConnections()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got failure with error: \(error)")
                }
            }, receiveValue: { connections in
                XCTAssertEqual(connections.count, 13)
                XCTAssertEqual(connections.first?.from, "London")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
