//
//  ArticleView.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/9/24.
//

import SwiftUI

struct ArticleView: View {
    @State var showFullView = false
    @StateObject var viewModel = ArticleViewModel()
    @State var articleInfo: article?
    let backgroundImg: String
    let defaultString = "N/A"
    
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
                Text("Article Of The Day")
                    .font(.system(size: 30, weight: .bold))
                    .padding(10) //
                    .foregroundColor(.brown)
                    .background(Color.offwhite)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.brown)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 350, height: 500)
                        .shadow(radius: 10) // Add shadow for depth
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1) // Add border
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
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) { // Increase spacing between elements
                                Button(action: {
                                    if let urlString = articleInfo?.url, let url = URL(string: urlString) {
                                        UIApplication.shared.open(url)
                                    }
                                    print("tap")
                                }) {
                                    Text(articleInfo?.title ?? "Title")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .underline(true, color: .blue)
                                    
                                }
                                
                                Text(articleInfo?.byline ?? defaultString)
                                    .font(.body)
                                    .foregroundColor(.white)
                                Text("section: \(articleInfo?.section ?? defaultString)")
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                Text(articleInfo?.abstract ?? defaultString)
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                
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
                    articleInfo = try await viewModel.fetchData()
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
    ArticleView( backgroundImg: "articleBg")
}
