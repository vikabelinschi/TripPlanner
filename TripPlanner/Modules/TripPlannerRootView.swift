//
//  TripPlannerRootView.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import SwiftUI

// MARK: - TripPlannerRootView
struct TripPlannerRootView: View {

    // MARK: - Properties
    @EnvironmentObject var coordinator: TripPlannerCoordinator

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeTripPlannerView()
                .navigationDestination(for: TripPlannerRoute.self) { destination in
                    switch destination {
                    case .routeMap:
                        if let viewModel = coordinator.currentRouteMapViewModel {
                            RouteMapView(viewModel: viewModel)
                        } else {
                            Text("No route data available.")
                        }
                    }
                }
        }
    }
}
