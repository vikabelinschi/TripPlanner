//
//  TripPlannerView.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 07.10.2024.
//

import Foundation
import SwiftUI

// MARK: - TripPlannerView
struct TripPlannerView<TripPlannerViewModel>: View where TripPlannerViewModel: TripPlannerViewModelProtocol{

    // MARK: - Properties
    @EnvironmentObject var coordinator: TripPlannerCoordinator
    @ObservedObject var viewModel: TripPlannerViewModel

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.allCities.isEmpty {
                searchFlightsView
                citySelectorView
                Spacer()
                findCheapestRouteButton
            } else {
                loadingView
            }
        }
        .padding()
        .onAppear {
            viewModel.getCities()
        }
        .bottomAlert(isVisible: $viewModel.noRouteAvailable, message: "No Route Available")
    }

    // MARK: - Search Flights View
    private var searchFlightsView: some View {
        Text("Search for flights")
            .font(.title)
            .fontWeight(.bold)
    }

    // MARK: - City Selector View
    private var citySelectorView: some View {
        HStack(alignment: .top) {
            CitySelectorView<CitySelectorViewModel>(
                selectedCity: $viewModel.fromCity,
                placeholder: "Departure",
                cities: viewModel.allCities
            )
            CitySelectorView<CitySelectorViewModel>(
                selectedCity: $viewModel.toCity,
                placeholder: "Destination",
                cities: viewModel.allCities
            )
        }
    }

    // MARK: - Find Cheapest Route Button
    private var findCheapestRouteButton: some View {
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
    }

    // MARK: - Loading View
    private var loadingView: some View {
        Text("Loading...")
    }
}

// MARK: - Body
#Preview {
    TripPlannerView(viewModel: TripPlannerViewModel(service: TripPlannerServiceImp()))
}
