//
//  FavouriteListView.swift
//  BallersApp
//
//  Created by Luigi Donnino on 18/12/24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            List {
                if favoritesManager.favorites.isEmpty {
                    Text("No favorite players yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(favoritesManager.favorites) { player in
                        HStack {
                            Text(player.name)
                                .font(.headline)
                            Spacer()
                            Text(player.cname ?? "Unknown Country")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
import Foundation

class FavoritesManager: ObservableObject {
    @Published var favorites: [Player] = []

    func addFavorite(_ player: Player) {
        if !isFavorite(player) {
            favorites.append(player)
        }
    }

    func removeFavorite(_ player: Player) {
        favorites.removeAll { $0.id == player.id }
    }

    func isFavorite(_ player: Player) -> Bool {
        favorites.contains { $0.id == player.id }
    }
}

