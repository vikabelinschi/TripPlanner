//
//  CityAnnotation.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import CoreLocation

// MARK: - CityAnnotation
struct CityAnnotation: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }

    static func == (lhs: CityAnnotation, rhs: CityAnnotation) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
