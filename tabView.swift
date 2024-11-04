//
//  TabBarView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/5/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView{
            ToDoView()
                .tabItem { Image(systemName: "pencil") }
 
            WeatherView()
                .tabItem { Image(systemName: "cloud.fill") }
                
            //
            TransportView()
                .tabItem { Image(systemName: "car.fill") }
                
            //
            MischeleaneousView()
                .tabItem { Image(systemName: "sparkles") }

        }
    }
}

#Preview {
    TabBarView()
}
