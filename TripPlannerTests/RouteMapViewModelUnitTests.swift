//
//  RouteMapViewModelUnitTests.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import XCTest
import CoreLocation
@testable import TripPlanner

class RouteMapViewModelUnitTests: XCTestCase {
    var viewModel: RouteMapViewModel!

    override func setUp() {
        super.setUp()

        let tripPlannerViewModel = TripPlannerViewModel(service: MockTripPlannerService())
        tripPlannerViewModel.getCities()
        let cityLocations = tripPlannerViewModel.cityLocations
        let connections = tripPlannerViewModel.connections
        let price = tripPlannerViewModel.totalPrice

        viewModel = RouteMapViewModel(route: connections, cityLocations: cityLocations, price: price)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSetupMapData() {
        XCTAssertFalse(viewModel.annotations.isEmpty, "Annotations should not be empty after setupMapData")
        XCTAssertFalse(viewModel.polylines.isEmpty, "Polylines should not be empty after setupMapData")

        let expectedCenter = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        XCTAssertNotEqual(viewModel.region.center.latitude, expectedCenter.latitude)
        XCTAssertNotEqual(viewModel.region.center.longitude, expectedCenter.longitude)
    }

    func testCalculateRegion() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 40.712776, longitude: -74.005974),
            CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683)  
        ]

        let region = viewModel.calculateRegion(for: coordinates)

        XCTAssertNotEqual(region.span.latitudeDelta, 0)
        XCTAssertNotEqual(region.span.longitudeDelta, 0)
        XCTAssert(region.span.latitudeDelta > 0 && region.span.latitudeDelta <= 180, "Latitude span is out of bounds")
        XCTAssert(region.span.longitudeDelta > 0 && region.span.longitudeDelta <= 360, "Longitude span is out of bounds")
    }
}
