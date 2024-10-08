//
//  TripPlannerViewModel.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 07.10.2024.
//

import Foundation
import Combine

// MARK: - TripPlannerViewModel
class TripPlannerViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var connections: [Connection] = []
    @Published var fromCity: String?
    @Published var toCity: String?
    @Published var cheapestRoute: [Connection] = []
    @Published var totalPrice: Double = 0.0
    @Published var cityLocations: [String: Location] = [:]
    @Published var allCities: [String] = []
    @Published var errorMessage: String?
    @Published var noRouteAvailable: Bool = false

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Dependencies
    let service: TripPlannerService

    // MARK: - Initializer
    init(service: TripPlannerService) {
        self.service = service
    }

    // MARK: - Computed Properties
    var canFindCheapestRoute: Bool {
        guard let fromCity = fromCity, let toCity = toCity else {
            return false
        }
        return !fromCity.isEmpty && !toCity.isEmpty && allCities.contains(fromCity) && allCities.contains(toCity)
    }

    // MARK: - Fetch Cities
    func getCities() {
        service.fetchConnections()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }, receiveValue: { [weak self] connections in
                guard let self else { return }
                self.connections = connections
                self.cityLocations = extractCities(from: connections)
                self.allCities = Array(self.cityLocations.keys).sorted()
            })
            .store(in: &cancellables)
    }

    // MARK: - Extract Cities from Connections
    private func extractCities(from connections: [Connection]) -> [String: Location] {
        var cityLocations = [String: Location]()
        for connection in connections {
            let fromCity = connection.from
            let toCity = connection.to
            let fromLocation = connection.coordinates.from
            let toLocation = connection.coordinates.to
            if cityLocations[fromCity] == nil {
                cityLocations[fromCity] = fromLocation
            }
            if cityLocations[toCity] == nil {
                cityLocations[toCity] = toLocation
            }
        }
        return cityLocations
    }

    // MARK: - Find Cheapest Route
    func findCheapestRoute() {
        var graph = [String: [Connection]]()
        for connection in connections {
            graph[connection.from, default: []].append(connection)
        }

        guard let fromCity, let toCity else {
            noRouteAvailable = true
            return
        }

        var routes = [String: (price: Double, path: [Connection])]()
        var priorityQueue = PriorityQueue<(city: String, price: Double)>(sort: { $0.price < $1.price })
        priorityQueue.enqueue((city: fromCity, price: 0))
        routes[fromCity] = (0, [])

        while let current = priorityQueue.dequeue() {
            let currentCity = current.city
            let currentPrice = current.price
            if currentCity == toCity {
                break
            }

            guard let outgoingConnections = graph[currentCity] else {
                continue
            }

            for connection in outgoingConnections {
                let nextCity = connection.to
                let newPrice = currentPrice + connection.price

                if let existingRoute = routes[nextCity] {
                    if newPrice < existingRoute.price {
                        routes[nextCity] = (newPrice, routes[currentCity]!.path + [connection])
                        priorityQueue.enqueue((city: nextCity, price: newPrice))
                    }
                } else {
                    routes[nextCity] = (newPrice, routes[currentCity]!.path + [connection])
                    priorityQueue.enqueue((city: nextCity, price: newPrice))
                }
            }
        }

        if let result = routes[toCity], !result.path.isEmpty {
            cheapestRoute = result.path
            totalPrice = result.price
            noRouteAvailable = false
        } else {
            cheapestRoute = []
            totalPrice = 0.0
            noRouteAvailable = true
        }
    }
}
