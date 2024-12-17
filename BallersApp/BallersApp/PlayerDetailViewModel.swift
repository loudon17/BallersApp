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
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Try to decode numberValue first (for cases like Height, Age, Market value)
        self.numberValue = try? container.decode(Double.self, forKey: .numberValue)
        
        // Decode key and fallback (for cases like Preferred foot and Country)
        self.key = try? container.decode(String.self, forKey: .key)
        self.fallback = try? container.decode(String.self, forKey: .fallback)

        // Decode options (for cases with units or currency style)
        self.options = try? container.decode([String: String].self, forKey: .options)
    }

    private enum CodingKeys: String, CodingKey {
        case numberValue, key, fallback, options
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
                    // Decode the response correctly
                    let decodedResponse = try JSONDecoder().decode(PlayerDetailResponse.self, from: data)
                    self?.playerDetails = decodedResponse.response.detail
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
