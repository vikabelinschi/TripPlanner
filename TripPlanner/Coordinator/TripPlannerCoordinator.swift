//
//  TripPlannerCoordinator.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import SwiftUI

// MARK: - TripPlannerCoordinator
class TripPlannerCoordinator: ObservableObject {

    // MARK: - Published Proerties
    @Published var path = NavigationPath()

    @Published var tripPlannerViewModel = TripPlannerViewModel(service: TripPlannerServiceImp())

    // MARK: - Properties
    var currentRouteMapViewModel: RouteMapViewModel?

    // MARK: - Make trip planner view
    func makeTripPlannerView() -> TripPlannerView {
        return TripPlannerView(viewModel: self.tripPlannerViewModel)
    }

    // MARK: - Go to cheapest route
    func goToCheapestRoute(route: [Connection], cityLocations: [String: Location], price: Double) {
        currentRouteMapViewModel = RouteMapViewModel(route: route, cityLocations: cityLocations, price: price)
        path.append(TripPlannerRoute.routeMap)
    }
}

// MARK: - Trip Planner Route
enum TripPlannerRoute: Hashable {
    case routeMap
}
