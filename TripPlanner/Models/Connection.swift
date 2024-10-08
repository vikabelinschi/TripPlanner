//
//  Connection.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation

// MARK: - Connection
struct Connection: Codable, Hashable {
    let from: String
    let to: String
    let coordinates: Coordinates
    let price: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(coordinates)
        hasher.combine(price)
    }

    static func == (lhs: Connection, rhs: Connection) -> Bool {
        return lhs.from == rhs.from &&
               lhs.to == rhs.to &&
               lhs.coordinates == rhs.coordinates &&
               lhs.price == rhs.price
    }
}

// MARK: - Coordinates
struct Coordinates: Codable, Hashable {
    let from: Location
    let to: Location
}

// MARK: - Location
struct Location: Codable, Hashable {
    let lat: Double
    let long: Double
}
