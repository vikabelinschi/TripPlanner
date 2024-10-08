//
//  TripPlannerService.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 07.10.2024.
//

import Foundation
import Combine

// MARK: - Trip Planner Service Protocol
protocol TripPlannerService {
    func fetchConnections() -> AnyPublisher<[Connection], Error>
}

// MARK: - Trip Planner Service Implementation
class TripPlannerServiceImp: TripPlannerService {
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Fetch connections
    func fetchConnections() -> AnyPublisher<[Connection], Error> {
        let persistenceService = PersistenceService.shared

        return URLSession.shared.dataTaskPublisher(for: Config.baseURL)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ConnectionsResponse.self, decoder: JSONDecoder())
            .map { response in
                persistenceService.saveConnections(response.connections)
                return response.connections
            }
            .catch { _ in
                Just(persistenceService.fetchConnections())
                    .setFailureType(to: Error.self)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
