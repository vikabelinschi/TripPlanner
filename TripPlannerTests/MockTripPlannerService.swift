//
//  MockTripPlannerService.swift
//  TripPlannerTests
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import Combine
import XCTest
@testable import TripPlanner

class MockTripPlannerService: TripPlannerService {
    var shouldReturnError = false

    func fetchConnections() -> AnyPublisher<[Connection], Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: "connections", withExtension: "json") else {
                return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
            }

            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(ConnectionsResponse.self, from: data)
                return Just(response.connections)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
}
