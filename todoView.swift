//
//  ToDoView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/5/24.
//

import SwiftUI

struct ToDoView: View {
    @ObservedObject var list = listClass()
    @State var showTypeView = false
    var body: some View {
        ZStack{
            VStack{
                //navbar stuff
                toDoNavBar(showTypeView: $showTypeView)
                
                //to do list
                List{
                    ForEach(list.itemArray){ item in
                        Text("\(item.name)")
                    }
                    .onDelete(perform: { indexSet in
                        list.deleteItem(index: indexSet)
                    })
                    
                }
                Spacer()
            }
            if showTypeView {
                newItemView(showView: $showTypeView, list: list)
            }
        }
    }
}

//to do and plus botton
struct toDoNavBar:View {
    @Binding var showTypeView: Bool
    
    var body: some View {
        HStack{
            Text("TO DO")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.foreground)
            
            Spacer()
            Button{
                showTypeView = true
            }label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .fontWeight(.semibold)
                    .foregroundStyle(.foreground)
                    .frame(width: 25, height: 25)
            }
        }
        .padding()
    }
}

//this is where the text field is
struct newItemView: View {
    @State var newItemInput = ""
    @Binding var showView: Bool
    @ObservedObject var list: listClass
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.opacity(0.1))
                .onTapGesture {
                    showView = false
                }
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 100)
                .frame(maxWidth: .infinity)

            TextField("newText", text: $newItemInput)
                .textFieldStyle(PlainTextFieldStyle())
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(maxWidth: .infinity) // Makes the TextField take full width
                .padding()
                .onSubmit {
                    let newItem = newItemInput
                    list.addItem(newItem: newItem)
                    showView.toggle()
                }
        }
    }
}

#Preview {
    ToDoView()
}
