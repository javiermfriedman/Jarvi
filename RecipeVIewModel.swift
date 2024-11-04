//
//  RecipeVIewModel.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/10/24.
//

import Foundation

struct RecipeNetworkResponse: Codable {
    let meals: [recipeInfo]
}

struct recipeInfo: Codable {
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strSource: String
    let strMealThumb: String
    
}


class RecipeViewModel: ObservableObject{
    
    func fetchData() async throws -> recipeInfo{
        let endpoint = "https://www.themealdb.com/api/json/v1/1/random.php"
        
        guard let url = URL(string: endpoint) else {
            throw wordError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw wordError.invalidNetwork
        }
        
        do{
            let decoder = JSONDecoder()
            let netResponse = try decoder.decode(RecipeNetworkResponse.self, from: data)
            let recipe = netResponse.meals.first
            return recipe!
            
        }catch{
            throw wordError.invalidData
        }
        
        
        
    }
}

