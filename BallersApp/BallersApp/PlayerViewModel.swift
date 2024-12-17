//
//  PlayerViewModel.swift
//  BallersApp
//
//  Created by Luigi Donnino on 16/12/24.
//
import Foundation
import SwiftUI
import UIKit




struct PlayerResponse: Decodable {
    let status: String
    let response: PlayerData
}

struct PlayerData: Decodable {
    let list: [PlayerGroup]
}

struct PlayerGroup: Decodable {
    let title: String
    let members: [Player]
}

struct Player: Identifiable, Decodable {
    let id: Int
    let name: String
    let shirtNumber: Int?
    let ccode: String?
    let cname: String?
    let positionId: Int?
    let rating: Double?
    let goals: Int?
    let penalties: Int?
    let assists: Int?
    let rcards: Int?
    let ycards: Int?
    let injured: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, shirtNumber, ccode, cname, positionId, rating, goals, penalties, assists, rcards, ycards, injured
    }
}
class PlayerViewModel: ObservableObject {
    @Published var playerGroups: [PlayerGroup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let headers = [
        "x-rapidapi-key": "a897764f83mshebe42e8b9eccf07p112bddjsnd54727328ffb",
        "x-rapidapi-host": "free-api-live-football-data.p.rapidapi.com"
    ]
    func fetchPlayers(for teamID: Int) {
        isLoading = true
        errorMessage = nil
        playerGroups = []  // Clear previous data

        let urlString = "https://free-api-live-football-data.p.rapidapi.com/football-get-list-player?teamid=\(teamID)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(PlayerResponse.self, from: data)
                    self?.playerGroups = decodedResponse.response.list
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
                
                // Dismiss the keyboard after the API request completes
                self?.dismissKeyboard()
            }
        }.resume()
    }

    // Helper function to dismiss the keyboard
    func dismissKeyboard() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.endEditing(true)
    }

}


