//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 04.10.2024.
//

import SwiftUI

@main
struct TripPlannerApp: App {
    @StateObject private var coordinator = TripPlannerCoordinator()

    var body: some Scene {
        WindowGroup {
            TripPlannerRootView()
                .environmentObject(coordinator)
        }
    }
}
