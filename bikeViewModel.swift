//
//  bikeViewModel.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/8/24.
//

import SwiftUI

struct ApiResponse: Codable{
    let network: Network
}

struct Network: Codable {
    let stations: [Station]
}

struct Station: Codable, Identifiable {
    let id: String
    let empty_slots: Int
    let extra: ExtraInfo
    let free_bikes: Int
    let name: String
}

struct ExtraInfo: Codable {
    let ebikes: Int
    let has_ebikes: Bool
    let slots: Int
    let uid: String
}

class bikeManager: ObservableObject {
    
    func fetchStations() async throws ->[Station] {
        
        let endpoint = "https://api.citybik.es/v2/networks/citi-bike-nyc"
        
        guard let url = URL(string: endpoint) else {
            throw TransportError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TransportError.invalidReponse
        }

        
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ApiResponse.self, from: data)
            return data.network.stations
        }catch{
            throw TransportError.invalidData
        }
    }
    
    
    
    
}

enum TransportError:Error{
    case invalidUrl
    case invalidReponse
    case invalidData
}
