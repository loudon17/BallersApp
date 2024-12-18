//
//  PlayerListView.swift
//  BallersApp
//
//  Created by Luigi Donnino on 16/12/24.
//

import SwiftUI

struct PlayerListView: View {
    @StateObject private var viewModel = PlayerViewModel()
    @State private var teamID: String = ""
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            VStack {
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
                                        NavigationLink(destination: PlayerDetailView(playerID: player.id)) {
                                            VStack(alignment: .leading) {
                                                Text(player.name)
                                                    .font(.headline)
                                                Text(player.cname ?? "Unknown Country")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()

                                        Button(action: {
                                            if favoritesManager.isFavorite(player) {
                                                favoritesManager.removeFavorite(player)
                                            } else {
                                                favoritesManager.addFavorite(player)
                                            }
                                        }) {
                                            Image(systemName: favoritesManager.isFavorite(player) ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ballers")
            
            
            
        }
    }
}

// PreviewProvider for PlayerListView
struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
            .environmentObject(FavoritesManager()) // Pass environment object for testing
    }
}

