//
//  RecipeView.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/10/24.
//

import SwiftUI

struct RecipeView: View {
    @State var showFullView = false
    @StateObject var viewModel = RecipeViewModel()
    @State var recipeInfo: recipeInfo?
    let backgroundImg: String
    
    var body: some View {
        ZStack {
            if showFullView == false {
                Image(backgroundImg)
                    .resizable()
                    .frame(width: 300, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        showFullView.toggle()
                    }
                Text("Random Recipe")
                    .font(.system(size: 30, weight: .bold))
                    .padding(10)
                    .foregroundColor(.brown)
                    .background(Color.offwhite)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.brown)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 350, height: 500)
                        .shadow(radius: 10) // 
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1) //
                        )
                    VStack{
                        HStack{
                            Spacer()
                            Button{
                                showFullView.toggle()
                            }label: {
                                Image(systemName: "x.square")
                                    .resizable()
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .frame(width: 25, height: 25)
                            }
                            .padding()
                        }
                        
                        ScrollView{
                            
                            
                            VStack{
                                Text(recipeInfo?.strMeal ?? "")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                
                                AsyncImage(url: URL(string: recipeInfo?.strMealThumb ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Text("loading Image...")
                    
                                }
                                .frame(width: 300)
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    Button(action: {
                                        if let urlString = recipeInfo?.strSource, let url = URL(string: urlString) {
                                            UIApplication.shared.open(url)
                                        }
                                        print("tap")
                                    }) {
                                        Text(recipeInfo?.strSource ?? "")
                                            .foregroundColor(.black)
                                        
                                    }

         
                                    Text("Instructions:")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                    Text(recipeInfo?.strInstructions ?? "")
                                        .font(.body)
                                    
                                }
                                
                            }
                            .padding()
                            
                            
                            
                            
                        }
                        
                        
                                
                        
                    }
                    .frame(width: 350, height: 500)
                }

            }
        }
        .onAppear {
            Task {
                do{
                    recipeInfo = try await viewModel.fetchData()
                } catch wordError.invalidUrl{
                    print("invalid url")
                } catch wordError.invalidData {
                    print("invalid data")
                } catch wordError.invalidNetwork {
                    print("invalid response")
                } catch {
                    print("unexpected error")
                }
                
            }
        }
    }
}



#Preview {
    RecipeView(backgroundImg: "cookoingback")
}

