//
//  PlayerdetailView.swift
//  BallersApp
//
//  Created by Luigi Donnino on 17/12/24.
//
import SwiftUI
import Foundation

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
                        
                        if let numberValue = detail.value.numberValue {
                            // Format number if it's currency or unit
                            if let options = detail.value.options, options["style"] == "currency" {
                                Text("\(numberValue, specifier: "%.1f")")
                                    .font(.body)
                            } else if let options = detail.value.options, options["style"] == "unit" {
                                Text("\(numberValue, specifier: "%.0f") \(options["unit"] ?? "")")
                                    .font(.body)
                            } else {
                                Text("\(numberValue, specifier: "%.0f")")
                                    .font(.body)
                            }
                        } else if let key = detail.value.key {
                            Text(key)
                                .font(.body)
                        } else if let fallback = detail.value.fallback {
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


