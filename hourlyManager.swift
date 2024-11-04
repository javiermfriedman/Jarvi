import SwiftUI

struct NetworkResponse: Codable {
    let list: [HourInfo]
}

struct HourInfo: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
}

enum WeatherError: Error {
    case invalidUrl
    case invalidNetwork
    case invalidData
}

class HourlyNetworkManager: ObservableObject {
    
    static func getData() async throws -> [HourInfo] {
        
        let apiKey = "46a15cd661e05dff110d0aced43a0868"
        let latitude = 40.81
        let longitude = -73.96
        let endpoint = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL: \(endpoint)")
            throw WeatherError.invalidUrl
        }
        
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
        
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid network response: \(response)")
                throw WeatherError.invalidNetwork
            }
            
            
            let decoder = JSONDecoder()
            let networkResponse = try decoder.decode(NetworkResponse.self, from: data)
            return networkResponse.list
            
        } catch {
            print("Error occurred: \(error)")
            throw WeatherError.invalidData
        }
    }
}
