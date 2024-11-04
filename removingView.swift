//
//  removingView.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/8/24.
//

import SwiftUI

struct removingView: View {
    @ObservedObject var transportList: TransportArrayViewModel
    @Binding var showView: Bool
    
    var body: some View {
        ZStack{
            VStack{
                if !transportList.arrayOfBikeStationsNames.isEmpty {
                    Text("current Bikes")
                    List{
                        ForEach(transportList.arrayOfBikeStationsNames) {station in
                            Text(station.name)
                        }
                        .onDelete(perform: { indexSet in
                            transportList.deleteItemBike(index: indexSet)
                            Task {
                                await transportList.fetchData()
                            }
                            
                        })
                    }
                } else {
                    Text("empty")
                    
                    
                }
            }
            VStack{
                
                
                if !transportList.arrayOfTrainStationsNames.isEmpty {
                    Text("Current Trains")
                    List{
                        ForEach(transportList.arrayOfTrainStationsNames) {station in
                            Text(station.name)
                        }
                        .onDelete(perform: { indexSet in
                            transportList.deleteItemTrain(index: indexSet)
                            
                        })
                    }
                    
                    
                } else {
                    Text("empty")
                }
            }
            
            
            
            
        }
        
        
            
        
        
      
    }
}

//#Preview {
//    removingView()
//}
