//
//  RouteMapViewModel.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import SwiftUI
import MapKit

// MARK: - RouteMapViewModel Class
class RouteMapViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
    )
    @Published var annotations: [CityAnnotation] = []
    @Published var polylines: [[CoordinatePoint]] = []

    // MARK: - Properties
    var cityLocations: [String: Location]
    var route: [Connection]
    var price: Double

    // MARK: - Initializer
    init(route: [Connection], cityLocations: [String: Location], price: Double) {
        self.route = route
        self.cityLocations = cityLocations
        self.price = price
        setupMapData()
    }

    // MARK: - Setup Map Data
    func setupMapData() {
        var coordinates: [CLLocationCoordinate2D] = []
        var annotationsSet = Set<CityAnnotation>()

        for connection in route {
            let fromCity = connection.from
            let toCity = connection.to

            guard let fromLocation = cityLocations[fromCity],
                  let toLocation = cityLocations[toCity] else { continue }

            let fromCoord = CLLocationCoordinate2D(latitude: fromLocation.lat, longitude: fromLocation.long)
            let toCoord = CLLocationCoordinate2D(latitude: toLocation.lat, longitude: toLocation.long)

            coordinates.append(contentsOf: [fromCoord, toCoord])

            annotationsSet.insert(CityAnnotation(title: fromCity, coordinate: fromCoord))
            annotationsSet.insert(CityAnnotation(title: toCity, coordinate: toCoord))

            let fromPoint = CoordinatePoint(latitude: fromLocation.lat, longitude: fromLocation.long)
            let toPoint = CoordinatePoint(latitude: toLocation.lat, longitude: toLocation.long)
            polylines.append([fromPoint, toPoint])
        }

        self.annotations = Array(annotationsSet)

        if !coordinates.isEmpty {
            region = calculateRegion(for: coordinates)
        }
    }

    // MARK: - Calculate Map Region
    func calculateRegion(for coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var minLat = coordinates.first?.latitude ?? 0
        var maxLat = coordinates.first?.latitude ?? 0
        var minLon = coordinates.first?.longitude ?? 0
        var maxLon = coordinates.first?.longitude ?? 0

        for coord in coordinates {
            minLat = min(minLat, coord.latitude)
            maxLat = max(maxLat, coord.latitude)
            minLon = min(minLon, coord.longitude)
            maxLon = max(maxLon, coord.longitude)
        }

        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2

        var spanLat = (maxLat - minLat) * 1.5
        var spanLon = (maxLon - minLon) * 1.5

        spanLat = min(max(spanLat, 0.01), 180)
        spanLon = min(max(spanLon, 0.01), 360)

        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
        )
    }
}
