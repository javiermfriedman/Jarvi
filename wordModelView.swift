//
//  WordOfDayViewModel.swift
//  Jarvis
//
//  Created by Javier Friedman on 8/7/24.
//

import SwiftUI

struct wordNetworkResponse: Codable {
    let word: String
    let definitions: [definition]
    let examples: [example]
}

struct definition: Codable {
    let text: String
    let partOfSpeech: String
}

struct example: Codable {
    let text: String
}



class wordNikVm: ObservableObject {
    @Published var wordData: wordNetworkResponse?
    
    func setData() async {
        do{
            let data = try await getData()
            DispatchQueue.main.async {
                self.wordData = data
            }
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


    
    func getData() async throws -> wordNetworkResponse{
        let endpoint = "https://api.wordnik.com/v4/words.json/wordOfTheDay?api_key=c0iu0nqhmalr4pam2xz4buh6gbi6cd5drmzfx305803876pjl"
        
        guard let url = URL(string: endpoint) else {
            throw wordError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw wordError.invalidNetwork
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(wordNetworkResponse.self, from: data)
            
        }catch{
            throw wordError.invalidData
        }

        
    }
    
}

enum wordError: Error{
    case invalidUrl
    case invalidNetwork
    case invalidData
}
