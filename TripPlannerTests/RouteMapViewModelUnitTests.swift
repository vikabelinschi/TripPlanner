//
//  RouteMapViewModelUnitTests.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import XCTest
import CoreLocation
@testable import TripPlanner

// MARK: - RouteMapViewModelTests
final class RouteMapViewModelTests: XCTestCase {
    private var viewModel: RouteMapViewModel!
    private var cityLocations: [String: Location]!
    private var route: [Connection]!

    // MARK: - Setup
    override func setUp() {
        super.setUp()

        cityLocations = [
            "New York": Location(lat: 40.7128, long: -74.0060),
            "Los Angeles": Location(lat: 34.0522, long: -118.2437),
            "Chicago": Location(lat: 41.8781, long: -87.6298)
        ]

        route = [
            Connection(from: "New York", to: "Chicago", coordinates: Coordinates(from: cityLocations["New York"]!, to: cityLocations["Chicago"]!), price: 200),
            Connection(from: "Chicago", to: "Los Angeles", coordinates: Coordinates(from: cityLocations["Chicago"]!, to: cityLocations["Los Angeles"]!), price: 300)
        ]

        viewModel = RouteMapViewModel(route: route, cityLocations: cityLocations, price: 500)
    }

    // MARK: - Teardown
    override func tearDown() {
        viewModel = nil
        cityLocations = nil
        route = nil
        super.tearDown()
    }

    // MARK: - Tests

    // Test that setupMapData correctly initializes annotations and polylines
    func testSetupMapData() {
        print(viewModel.annotations)
        XCTAssertEqual(viewModel.annotations.count, 3) // New York, Chicago, Los Angeles
        XCTAssertEqual(viewModel.polylines.count, 2) // Two connections in the route
    }

    // Test that the region is calculated correctly for the given coordinates
    func testCalculateRegion() {
        // Given
        let coordinates = [
            CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298),
            CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        ]

        // When
        let calculatedRegion = viewModel.calculateRegion(for: coordinates)

        // Then
        XCTAssertEqual(calculatedRegion.center.latitude, 37.96515, accuracy: 0.1)
        XCTAssertEqual(calculatedRegion.center.longitude, -96.12485, accuracy: 0.1)
        XCTAssertGreaterThan(calculatedRegion.span.latitudeDelta, 0.01)
        XCTAssertGreaterThan(calculatedRegion.span.longitudeDelta, 0.01)
    }


    // Test that the annotations contain the correct titles and coordinates
    func testAnnotationsContainCorrectData() {
        // Given
        viewModel.setupMapData()

        // When
        let annotationTitles = viewModel.annotations.map { $0.title }
        let expectedTitles = ["New York", "Chicago", "Los Angeles"]

        // Then
        XCTAssertEqual(annotationTitles.sorted(), expectedTitles.sorted())
    }

    // Test that the polylines contain the correct number of points
    func testPolylinesContainCorrectData() {

        // When
        let polylinePoints = viewModel.polylines.flatMap { $0 }

        // Then
        XCTAssertEqual(polylinePoints.count, 4) // Two points per connection in two connections
    }

    // Test that the region is adjusted properly when coordinates are empty
    func testEmptyCoordinatesYieldsDefaultRegion() {
        // Given
        let emptyCoordinates: [CLLocationCoordinate2D] = []

        // When
        let defaultRegion = viewModel.calculateRegion(for: emptyCoordinates)

        // Then
        XCTAssertEqual(defaultRegion.center.latitude, 0)
        XCTAssertEqual(defaultRegion.center.longitude, 0)
        XCTAssertEqual(defaultRegion.span.latitudeDelta, 50)
        XCTAssertEqual(defaultRegion.span.longitudeDelta, 50)
    }
}
