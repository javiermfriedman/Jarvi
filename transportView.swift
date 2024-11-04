//
//  TransportView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/8/24.
//

import SwiftUI

struct TransportView: View {
    @ObservedObject var transportArrayClass = TransportArrayViewModel()
    @State var showMyTransports = false
    @State var showRemoveList = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.gray, .gray2], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack{
                HStack{
                    plusButton(showView: $showMyTransports)
                    Button{
                        showRemoveList.toggle()
                    }label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                ScrollView{
                    if transportArrayClass.isLoading {
                        // Show a loading indicator while data is being fetched
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        // Show the fetched data
                        ForEach(transportArrayClass.myBikeStations) { station in
                            CitiBikeCardView(station: station)
                        }
                    }
                }
            
            Spacer()

            }
        }
        .onAppear(){
            Task {
                await transportArrayClass.fetchData()
            }
        }
        .sheet(isPresented: $showRemoveList, content: {
            removingView(transportList: transportArrayClass, showView: $showRemoveList)
        })
        .sheet(isPresented: $showMyTransports, content: {
            myTransportView(transportList: transportArrayClass, showView: $showMyTransports)
                .presentationDetents([.medium])
                
        })
    }
    
}




#Preview {
    TransportView()
}
