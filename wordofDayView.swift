//
//  wordOfDayView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/7/24.
//



import SwiftUI

struct wordOfDayView: View {
    @StateObject var wordResponse = wordNikVm()
    @State var showFull = false
    let backgroundImg: String
    
    var body: some View {
        ZStack {
            if showFull == false {
                
                Image(backgroundImg)
                    .resizable()
                    .frame(width: 300, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        showFull.toggle()
                    }
                Text("word of the day")
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
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            if let data = wordResponse.wordData {
                                HStack{
                                    Text(data.word)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 10)
                                    Spacer()
                                    Button{
                                        showFull.toggle()
                                    }label: {
                                        Image(systemName: "x.square")
                                            .resizable()
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .frame(width: 25, height: 25)
                                    }
                                    
                                }
                                
                                
                                Text("Definitions")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 5)
                                
                                ForEach(data.definitions, id: \.text) { definition in
                                    Text("• \(definition.text)")
                                        .padding(.bottom, 2)
                                }
                                
                                Text("Examples")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.top, 10)
                                    .padding(.bottom, 5)
                                
                                ForEach(data.examples, id: \.text) { example in
                                    Text("• \(example.text)")
                                        .padding(.bottom, 2)
                                }
                                
                            } else {
                                Text("Loading...")
                                    .padding()
                            }
                        }
                        .padding()
                    }
                    .frame(width: 350, height: 500)
                }
            }
        }
        .onAppear {
            Task {
                await wordResponse.setData()
            }
        }
    }
}

#Preview {
    wordOfDayView(backgroundImg: "book")
}


#Preview {
    wordOfDayView( backgroundImg: "book")
}
