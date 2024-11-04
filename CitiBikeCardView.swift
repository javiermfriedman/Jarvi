//
//  CitiBikeCardView.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/8/24.
//

import SwiftUI

struct CitiBikeCardView: View {
    let station: Station
    
    var body: some View {
        ZStack{
            Image("citibike2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
            VStack(alignment: .center, spacing: 10) {
                Text(station.name)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 5)
                    
                
                VStack{
                    Text("E-Bikes: \(station.extra.ebikes)")
                    Text("Classic Bikes: \(getNumClassic())")
                    Text("Empty Slots: \(station.empty_slots)")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding()
                
            }
            .foregroundStyle(.white)
            .frame(width: 300, height: 200)
        }
        
        .clipShape(RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/))
        }
    
    func getNumClassic() -> Int {
        let numTotal = station.free_bikes
        let numEbikes = station.extra.ebikes
        let numClassic = numTotal - numEbikes
        
        print(numTotal)
        print(numEbikes)
        print(numClassic)
        return numClassic
        
    }
    
}

//#Preview {
//    CitiBikeCardView()
//}
//
