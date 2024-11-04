//
//  CurrentWeatherNet.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/7/24.
//

import Foundation

//models
struct WeatherResponse: Codable {
    let weather: [weatherIndex]
    let main: Main
}

struct weatherIndex: Codable {
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}

//view model
class currentNetworkManager {
    static func getData() async throws -> WeatherResponse{
        let apiKey = "3fbe7601de354397948361c0682c1bf3"
        let latitude = 40.81
        let longitude = -73.96
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKey)"
    
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            throw weatherError.invalidUrl
        }
            
        let (data, response) = try await URLSession.shared.data(from: url)
        
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid network response: \(response)")
            throw weatherError.invalidNetwork
        }
        
        let decoder = JSONDecoder()
        do {
            //get the entire new york citi bike network
            let weaterman = try decoder.decode(WeatherResponse.self, from: data)
            return weaterman
        } catch {
            print("Error decoding data: \(error)")
            throw wordError.invalidData
        }
        
    }
    
}
