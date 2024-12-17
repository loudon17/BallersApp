//
//  PlayerDetailViewModel.swift
//  BallersApp
//
//  Created by Luigi Donnino on 17/12/24.
//

import Foundation
import SwiftUI


// Main response structure for player details
struct PlayerDetailResponse: Codable {
    let status: String
    let response: PlayerDetail
}

// Player detail structure containing the details of a player
struct PlayerDetail: Codable {
    let detail: [PlayerDetailItem]
}

// A single player detail item containing a title and value
struct PlayerDetailItem: Codable {
    let title: String
    let value: PlayerDetailValue
}

// A value that can either be a number, string, or other complex types
struct PlayerDetailValue: Codable {
    let numberValue: Double?
    let key: String?
    let fallback: String?
    let options: [String: String]?
    
    // Custom initializer to handle different JSON formats for 'value'
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as a dictionary with 'numberValue' and other fields
        if let dict = try? container.decode([String: String].self) {
            self.numberValue = nil
            self.key = dict["key"]
            self.fallback = dict["fallback"]
            self.options = dict
        }
        // Try to decode as a number (for values like "height", "age", etc.)
        else if let numberValue = try? container.decode(Double.self) {
            self.numberValue = numberValue
            self.key = nil
            self.fallback = nil
            self.options = nil
        }
        // Try to decode as a string
        else if let fallback = try? container.decode(String.self) {
            self.fallback = fallback
            self.numberValue = nil
            self.key = nil
            self.options = nil
        } else {
            self.numberValue = nil
            self.key = nil
            self.fallback = nil
            self.options = nil
        }
    }
}



private let headers = [
        "x-rapidapi-key": "a897764f83mshebe42e8b9eccf07p112bddjsnd54727328ffb",
        "x-rapidapi-host": "free-api-live-football-data.p.rapidapi.com"
    ]
class PlayerDetailViewModel: ObservableObject {
    @Published var playerDetails: [PlayerDetailItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchPlayerDetails(for playerID: Int) {
        isLoading = true
        errorMessage = nil
        let urlString = "https://free-api-live-football-data.p.rapidapi.com/football-get-player-detail?playerid=\(playerID)"
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
                    let decodedResponse = try JSONDecoder().decode(PlayerDetailResponse.self, from: data)
                    self?.playerDetails = decodedResponse.response.detail
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
