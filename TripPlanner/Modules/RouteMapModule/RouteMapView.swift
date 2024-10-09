//
//  RouteMapViewModel.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 07.10.2024.
//

import SwiftUI
import MapKit

// MARK: - RouteMapView
struct RouteMapView<RouteMapViewModel>: View where RouteMapViewModel: RouteMapViewModelProtocol{
    @StateObject private var viewModel: RouteMapViewModel

     // MARK: - Initialization
     init(viewModel: RouteMapViewModel) {
         _viewModel = StateObject(wrappedValue: viewModel)
     }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            mapView
            routeDetailsView
            totalPriceView
        }
    }

    // MARK: - Map View
    private var mapView: some View {
        ZStack {
            Map {
                if !viewModel.annotations.isEmpty {
                    ForEach(viewModel.annotations, id: \.self) { annotation in
                        Annotation(annotation.title, coordinate: annotation.coordinate) {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "mappin.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                        }
                    }
                }

                ForEach(viewModel.polylines, id: \.self) { polylineCoordinates in
                    MapPolyline(coordinates: polylineCoordinates.map { $0.coordinate })
                        .stroke(Color.blue, lineWidth: 3)
                }
            }
            .mapStyle(.standard)
        }
    }

    // MARK: - Route Details View
    private var routeDetailsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Route Details:")
                .font(.headline)
                .padding(.horizontal)

            ForEach(viewModel.route, id: \.self) { connection in
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.blue)
                    Text("\(connection.from) -> \(connection.to)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }

    // MARK: - Total Price View
    private var totalPriceView: some View {
        Text("Total Price: \(viewModel.price, specifier: "%.0f")$")
            .font(.callout)
            .fontWeight(.bold)
            .padding()
    }
}
