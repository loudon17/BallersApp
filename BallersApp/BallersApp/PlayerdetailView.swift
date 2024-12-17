//
//  PlayerdetailView.swift
//  BallersApp
//
//  Created by Luigi Donnino on 17/12/24.
//
import SwiftUI

struct PlayerDetailView: View {
    @StateObject private var viewModel = PlayerDetailViewModel()
    let playerID: Int

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                List(viewModel.playerDetails, id: \.title) { detail in
                    HStack {
                        Text(detail.title)
                            .font(.headline)
                            .frame(width: 120, alignment: .leading)
                        Spacer()

                        // Handle numberValue with different options like currency and unit
                        if let numberValue = detail.value.numberValue {
                            // Handle currency format
                            if let options = detail.value.options, options["style"] == "currency" {
                                let currency = options["currency"] ?? ""
                                Text("\(currency) \(numberValue, specifier: "%.1f")")
                                    .font(.body)
                            }
                            // Handle unit format
                            else if let options = detail.value.options, options["style"] == "unit" {
                                let unit = options["unit"] ?? ""
                                Text("\(numberValue, specifier: "%.0f") \(unit)")
                                    .font(.body)
                            }
                            // Handle plain number format
                            else {
                                Text("\(numberValue, specifier: "%.0f")")
                                    .font(.body)
                            }
                        }
                        // Handle key as a string (e.g., Left, Greece)
                        else if let key = detail.value.key {
                            Text(key)
                                .font(.body)
                        }
                        // Handle fallback string (e.g., "Greece", "Left")
                        else if let fallback = detail.value.fallback {
                            Text(fallback)
                                .font(.body)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPlayerDetails(for: playerID)
        }
        .navigationTitle("Player Details")
    }
}

