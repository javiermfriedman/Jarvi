//
//  MischeleaneousView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/5/24.
//

import SwiftUI

struct MischeleaneousView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.brown1, .brown2]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
                ScrollView{
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.brown)
                                .frame(width: 315, height: 165)
                            wordOfDayView(backgroundImg: "book")
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.brown)
                                .frame(width: 315, height: 165)
                            ArticleView(backgroundImg: "articleBg")
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.brown)
                                .frame(width: 315, height: 165)
                            RecipeView(backgroundImg: "cookoingback")
                        }
                       
                            .padding()
                        
                    }

                }

        }
    }
}



#Preview {
    MischeleaneousView()
}
