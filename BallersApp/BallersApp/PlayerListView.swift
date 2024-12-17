//
//  PlayerListView.swift
//  BallersApp
//
//  Created by Luigi Donnino on 16/12/24.
//
import SwiftUI

struct PlayerListView: View {
    @StateObject private var viewModel = PlayerViewModel()
    @State private var teamID: String = ""  // Holds team ID input

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Enter Team ID", text: $teamID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        if let id = Int(teamID), id > 0 {
                            viewModel.fetchPlayers(for: id)
                        }
                    }) {
                        Text("Search")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                // Player List or Loading/Error Views
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(viewModel.playerGroups, id: \.title) { group in
                            Section(header: Text(group.title.capitalized)) {
                                ForEach(group.members) { player in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(player.name)
                                                .font(.headline)
                                            Text(player.cname ?? "Unknown Country")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        if let rating = player.rating {
                                            Text(String(format: "%.2f", rating))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Team Players")
        }
    }
}

