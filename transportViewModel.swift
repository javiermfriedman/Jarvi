//
//  TransportViewModel.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/8/24.
//

import SwiftUI

struct myBikeStation: Identifiable, Codable {
    var id: String
    let name: String

    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}

struct myTrainStation: Identifiable, Codable {
    var id: String
    let name: String

    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}
class TransportArrayViewModel: ObservableObject {
    @ObservedObject var bikeNetwork = bikeManager()
    
    @Published var isLoading: Bool = false
    @Published var myBikeStations: [Station] = []
    
    private var fetchedStations: [Station] = []
    
    
    @Published var arrayOfBikeStationsNames: [myBikeStation] = [] {
        didSet {
            saveItems()
        }
    }
    @Published var arrayOfTrainStationsNames: [myTrainStation] = [] {
        didSet {
            saveItems()
        }
    }

    private let BikeItemsKey = "bikeItems"
    private let TrainItemsKey = "trainItems"

    init() {
        loadItems()
    }
    
    func fetchData() async {
        do{
            print("called fetchData")
            self.isLoading = true
            let stationData = try await bikeNetwork.fetchStations()
            
            print("setting fetched data equal to data")
            fetchedStations = stationData
            
            
            // Extract the names from arrayOfBikeStations
            let bikeStationNames = Set(arrayOfBikeStationsNames.map { $0.name })
            
            // Filter the fetched stations based on the names
            let matchingStations = stationData.filter { station in
                bikeStationNames.contains(station.name)
            }
            
            myBikeStations.removeAll()
            
            // Append the matching stations to myStations
            myBikeStations.append(contentsOf: matchingStations)
            self.isLoading = false
            
        } catch TransportError.invalidUrl{
            print("invalid url")
        } catch TransportError.invalidData {
            print("invalid data")
        } catch TransportError.invalidReponse {
            print("invalid response")
        } catch {
            print("unexpected error")
        }
    }

    func addItemToBikes(newItem: String) -> Bool {
        // Check if the new item is already in arrayOfBikeStationsNames
        if arrayOfBikeStationsNames.contains(where: { $0.name == newItem }) {
            print("Bike station \(newItem) already exists.")
            return false
        }
        
        // Check if the new item exists in fetchedStations
        guard let stationToAdd = fetchedStations.first(where: { $0.name == newItem }) else {
            print("Station name \(newItem) not found in fetched data.")
            return false
        }
        
        // Add the new item to arrayOfBikeStationsNames
        let newBikeStation = myBikeStation(name: newItem)
        arrayOfBikeStationsNames.append(newBikeStation)
        
        // Add the new item to myBikeStations
        myBikeStations.append(stationToAdd)
        
        return true
    }


    func addItemToTrains(newItem: String) {
        arrayOfTrainStationsNames.append(myTrainStation(name: newItem))
    }
    
    func deleteItemBike(index: IndexSet) {
        arrayOfBikeStationsNames.remove(atOffsets: index)
            let namesToDelete = arrayOfBikeStationsNames.map { $0.name }
            myBikeStations.removeAll { station in
                namesToDelete.contains(station.name)
        }
    }
    
    func deleteItemTrain(index: IndexSet) {
        arrayOfTrainStationsNames.remove(atOffsets: index)
    }
    

    private func saveItems() {
        let bikeEncoder = JSONEncoder()
        if let bikeEncoded = try? bikeEncoder.encode(arrayOfBikeStationsNames) {
            UserDefaults.standard.set(bikeEncoded, forKey: BikeItemsKey)
        }

        let trainEncoder = JSONEncoder()
        if let trainEncoded = try? trainEncoder.encode(arrayOfTrainStationsNames) {
            UserDefaults.standard.set(trainEncoded, forKey: TrainItemsKey)
        }
    }

    private func loadItems() {
        if let savedBikeItems = UserDefaults.standard.data(forKey: BikeItemsKey) {
            let bikeDecoder = JSONDecoder()
            if let decodedBikeItems = try? bikeDecoder.decode([myBikeStation].self, from: savedBikeItems) {
                arrayOfBikeStationsNames = decodedBikeItems
            }
        }

        if let savedTrainItems = UserDefaults.standard.data(forKey: TrainItemsKey) {
            let trainDecoder = JSONDecoder()
            if let decodedTrainItems = try? trainDecoder.decode([myTrainStation].self, from: savedTrainItems) {
                arrayOfTrainStationsNames = decodedTrainItems
            }
        }
    }
}
