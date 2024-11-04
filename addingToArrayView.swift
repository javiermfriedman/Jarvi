//
//  AddingToArrayView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/8/24.
//

import SwiftUI

struct myTransportView: View {
    @ObservedObject var transportList: TransportArrayViewModel
    @State var newItemInput = ""
    @Binding var showView: Bool
    @State var whichArray = ""
    @State var clicked = false
    @State var inValidInput = false
    
    var body: some View {
        ZStack{
            
            VStack{
                citiButtonsView(whichTranport: $whichArray, clicked: $clicked)
                    .padding(.top, 5)
                
                if inValidInput {
                    Text("invalid station")
                }
                
                
                
                if clicked{
                        
                    
                    TextField("Enter Station Name Correctly", text: $newItemInput)
                        .textFieldStyle(PlainTextFieldStyle())
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity) // Makes the TextField take full width
                        .padding()
                        .onSubmit {
                            let newItem = newItemInput
                            if whichArray == "bike"{
                                if !transportList.addItemToBikes(newItem: newItem){
                                    inValidInput = true
                                }
                                
                            } else if whichArray == "train"{
                                print("add to train")
                            }
                            
                            
                            showView.toggle()
                            Task {
                                await transportList.fetchData()
                            }
                        }
                    
                }
                
                
            }
        }
    }

}


struct citiButtonsView: View {
    @Binding var whichTranport: String
    @Binding var clicked: Bool
    
    var body: some View {
        HStack{
            if !clicked{
                Button{
                    whichTranport = "bike"
                    clicked.toggle()
                }label: {
                    tansportButton(color: .blue, text: "bike")
                }
                Button{
                    whichTranport = "train"
                    clicked.toggle()
                }label: {
                    tansportButton(color: .red, text: "train")
                }
            } else {
                if whichTranport == "bike" {
                    tansportButton(color: .blue, text: "bike")
                    tansportButton(color: .red.opacity(0.5), text: "train")
                    
                } else {
                    tansportButton(color: .blue.opacity(0.5), text: "bike")
                    tansportButton(color: .red.opacity(0.5), text: "train")
                }
            
                
            }
            
            
        }
    }
}

struct tansportButton: View {
    let color: Color
    let text: String
    var body: some View {
        ZStack{
            Rectangle()
                .fill(color)
                .frame(width: 200, height: 200)
            Text(text)
                .foregroundStyle(.white)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
        }
        
    }
}

struct plusButton: View {
    @Binding var showView: Bool
    
    var body: some View {
        HStack{
            Button{
                showView.toggle()
                
            }label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.white)
                    .padding()
            }
            Spacer()
        }
    }
}

#Preview {
    plusButton(showView: .constant(true))
}
