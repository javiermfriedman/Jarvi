//
//  WeatherViewModel.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/7/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var currentWeather: WeatherResponse?
    @Published var hourWeather: [HourInfo]?
    
    func setCurrent() async {
        do{
            let data = try await currentNetworkManager.getData()
         
            DispatchQueue.main.async {
                self.currentWeather = data
            }  
        } 
        
        
        catch weatherError.invalidUrl{
            print("invalid url")
        } catch weatherError.invalidData {
            print("invalid data")
        } catch weatherError.invalidNetwork {
            print("invalid response")
        } catch {
            print("unexpected error")
        }
            
    }
    func setHourly() async {
        do {
            let hours = try await HourlyNetworkManager.getData()
            DispatchQueue.main.async {
                self.hourWeather = hours
            }
        } catch {
                print("Failed to fetch data: \(error)")
        }
        
        
            
        

    }
    
    
    func getIcon(description: String) ->String{
        
        if description == "Rain" {
            return "cloud.drizzle.fill"
        } else if description == "thunderstorm" {
            return "cloud.bolt.rain"
        } else if description == "Snow" {
            return "cloud.snow"
        } else if description == "Mist" {
            return "smoke.fill"
        } else if description == "Clear sky" {
            return "sun.max.fill"
        } else if description == "Few clouds" {
            return "cloud.sun.fill"
        } else if description == "Scattered clouds" {
            return "cloud.fill"
        } else if description == "Broken clouds" {
            return "cloud.fill"
        } else if description == "Shower rain" {
            return "cloud.heavyrain.fill"
        }  else if description == "Clouds" {
            return "cloud.fill"
        } else {
            return "cloud.sun.fill"
        }
    }
}

enum weatherError: Error{
    case invalidUrl
    case invalidNetwork
    case invalidData
}

