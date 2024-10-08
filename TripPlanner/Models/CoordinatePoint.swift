//
//  CoordinatePoint.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import CoreLocation

// MARK: - CoordinatePoint
struct CoordinatePoint: Hashable {
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    static func == (lhs: CoordinatePoint, rhs: CoordinatePoint) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
