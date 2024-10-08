//
//  TripPlannerView.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 07.10.2024.
//

import Foundation
import SwiftUI

// MARK: - TripPlannerView
struct TripPlannerView: View {

    // MARK: - Properties
    @EnvironmentObject var coordinator: TripPlannerCoordinator
    @ObservedObject var viewModel: TripPlannerViewModel

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.allCities.isEmpty {
                Text("Search for flights")
                    .font(.title)
                    .fontWeight(.bold)
                HStack(alignment: .top) {
                    CitySelectorView(selectedCity: $viewModel.fromCity, cities: viewModel.allCities, placeholder: "Departure")
                    CitySelectorView(selectedCity: $viewModel.toCity, cities: viewModel.allCities, placeholder: "Destination")
                }
                Spacer()
                Button(action: {
                    viewModel.findCheapestRoute()
                    if !viewModel.cheapestRoute.isEmpty {
                        coordinator.goToCheapestRoute(route: viewModel.cheapestRoute, cityLocations: viewModel.cityLocations, price: viewModel.totalPrice)
                    }
                }) {
                    HStack {
                        Text("Find Cheapest Route")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(viewModel.canFindCheapestRoute ? Color.blue : Color.gray)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 60)
                .disabled(!viewModel.canFindCheapestRoute)
                .opacity(viewModel.canFindCheapestRoute ? 1.0 : 0.6)
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .onAppear {
            viewModel.getCities()
        }
        .bottomAlert(isVisible: $viewModel.noRouteAvailable, message: "No Route Available")
    }
}

// MARK: - Body
#Preview {
    TripPlannerView(viewModel: TripPlannerViewModel(service: TripPlannerServiceImp()))
}
