//
//  BallersAppApp.swift
//  BallersApp
//
//  Created by Luigi Donnino on 16/12/24.
//

import SwiftUI

@main
struct BallersApp: App {
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    PlayerListView()
                        .environmentObject(favoritesManager)
                }
                .tabItem {
                    Label("Players", systemImage: "list.bullet")
                }

                NavigationView {
                    FavoritesView()
                        .environmentObject(favoritesManager)
                }
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            }
        }
    }
}



