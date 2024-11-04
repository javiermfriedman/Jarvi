//
//  ToDoModelView.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/5/24.
//

import Foundation
import SwiftUI

// Make Item conform to Codable and handle the UUID properly
struct Item: Identifiable, Codable {
    var id: String
    let name: String

    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}

class listClass: ObservableObject {
    @Published var itemArray: [Item] = [] {
        didSet {
            saveItems()
        }
    }
    @Published var isEmpty: Bool = true
    
    private let itemsKey = "items"
    
    init() {
        loadItems()
        updateEmptyState()
    }
    
    func addItem(newItem: String) {
        itemArray.append(Item(name: newItem))
        updateEmptyState()
    }
    
    func deleteItem(index: IndexSet) {
        itemArray.remove(atOffsets: index)
        updateEmptyState()
    }
    
    func replaceItem(at index: Int, with newItem: Item) {
        if itemArray.indices.contains(index) {
            itemArray[index] = newItem
        }
    }

    
    private func updateEmptyState() {
        isEmpty = itemArray.isEmpty
    }
    
    private func saveItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(itemArray) {
            UserDefaults.standard.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: itemsKey) {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([Item].self, from: savedItems) {
                itemArray = decodedItems
            }
        }
    }
}
