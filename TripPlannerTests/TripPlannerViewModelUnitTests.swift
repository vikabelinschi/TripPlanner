//
//  TripPlannerViewModelUnitTests.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import XCTest
import Combine
@testable import TripPlanner

class TripPlannerViewModelUnitTests: XCTestCase {
    var viewModel: TripPlannerViewModel!
    var mockService: MockTripPlannerService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockService = MockTripPlannerService()
        viewModel = TripPlannerViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = []
        super.tearDown()
    }

    func testGetCitiesSuccess() {
        let expectation = XCTestExpectation(description: "Fetch cities successfully from service")

        viewModel.getCities()


        viewModel.$allCities
            .sink(receiveValue: { cities in
                if !cities.isEmpty {
                    XCTAssertEqual(cities.count, 13)
                    XCTAssertTrue(cities.contains("Berlin"))
                    XCTAssertTrue(cities.contains("Tokyo"))
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0)
    }

    func testFindCheapestRoute() {
        mockService.shouldReturnError = false

        let fetchCitiesExpectation = XCTestExpectation(description: "Fetch cities successfully from service")
        viewModel.getCities()

        viewModel.$allCities
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error fetching cities: \(error)")
                }
            }, receiveValue: { cities in
                if !cities.isEmpty {
                    fetchCitiesExpectation.fulfill()
                }
            })
            .store(in: &cancellables)

        wait(for: [fetchCitiesExpectation], timeout: 5.0)

        viewModel.fromCity = "London"
        viewModel.toCity = "Tokyo"

        let expectation = XCTestExpectation(description: "Find the cheapest route between London and Tokyo")

        viewModel.$cheapestRoute
            .dropFirst()
            .sink(receiveValue: { route in
                if !route.isEmpty {
                    XCTAssertEqual(route.first?.from, "London")
                    XCTAssertEqual(route.last?.to, "Tokyo")
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        viewModel.$totalPrice
            .dropFirst()
            .sink(receiveValue: { price in
                XCTAssertEqual(price, 2400)
            })
            .store(in: &cancellables)

        viewModel.findCheapestRoute()

        wait(for: [expectation], timeout: 5.0)
    }


    func testGetCitiesFailure() {
        mockService.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Fetch cities should fail")

        viewModel.getCities()

        viewModel.$errorMessage
            .dropFirst() 
            .sink(receiveValue: { errorMessage in
                if let errorMessage = errorMessage {
                    XCTAssertTrue(errorMessage.contains("Error:"))
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
