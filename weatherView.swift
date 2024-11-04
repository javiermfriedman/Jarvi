//  WeatherView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/5/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.blue, Color("WeatherViewBlue")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                    currentView(viewModel: viewModel)
                Spacer()
                VStack{
                    ZStack{
                        LinearGradient(
                            gradient: Gradient(colors: [Color.weatherViewBlue, Color.theSLgihblue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        Color.theSLgihblue
                        hourlyView(viewModel: viewModel)
                    }
                    
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/))
                .padding()
                    
                
                Spacer()
                
                
            }
                
        }
    }
}

struct currentView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack{
            if let currentWeather = viewModel.currentWeather {

                let weatherIndex = currentWeather.weather.first?.main
                Image(systemName: viewModel.getIcon(description: weatherIndex ?? ""))
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)

                Text("New York, New York")
                    .font(.system(size: 30, weight: .medium, design: .default))
                    .foregroundColor(.white)
                Text("\(String(format: "%.1f", currentWeather.main.temp))°F")
                    .font(.system(size: 70, weight: .light))
                    .foregroundColor(.white)


            } else {
                Text("Loading...")
                    .onAppear {
                        Task {
                            await viewModel.setCurrent()
                        }
                    }
            }
        }
    }
}

struct hourlyView: View {
    @ObservedObject var viewModel: WeatherViewModel
        
        var body: some View {
            VStack {
                
                if let hourlyWeather = viewModel.hourWeather {
                    
                    
                    let currentTime = Date()
                    let futureTime = Calendar.current.date(byAdding: .hour, value: 12, to: currentTime)!

                    // Filter hourlyWeather to include only the next 24 hours
                    let filteredWeather = hourlyWeather.filter { hour in
                        let hourDate = Date(timeIntervalSince1970: TimeInterval(hour.dt))
                        return hourDate >= currentTime && hourDate <= futureTime
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) { // Horizontal scroll view
                        HStack(spacing: 16) {
                            
                            ForEach(filteredWeather, id: \.dt) { hour in
                                VStack(alignment: .center, spacing: 8) {
                                    Text(formattedHour(from: hour.dt))
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        
                                    let weather = hour.weather.first?.main
                                    
                                    Image(systemName: viewModel.getIcon(description: weather ?? ""))
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
                                    
                                    
                                    Text("\(String(format: "%.1f", hour.main.temp))°F")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .cornerRadius(10) // Rounded corners
                                .shadow(radius: 5) // Optional shadow for better appearance
                            }
                        }
                        .padding() // Padding around the HStack
                    }
                    
                } else {
                    Text("Loading hourly data...")
                        .onAppear {
                            Task {
                                await viewModel.setHourly()
                            }
                        }
                }
            }
        }
    
    func formattedHour(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // "h a" will show hour and AM/PM
        return formatter.string(from: date)
    }
}


#Preview {
    WeatherView()
}
