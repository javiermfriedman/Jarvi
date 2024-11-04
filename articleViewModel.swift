//
//  articleViewModel.swift
//  Jarvi
//
//  Created by Javier Friedman on 8/9/24.
//

import Foundation

struct ArticleResponse: Decodable {
    let results: [article]
    
}

struct article: Decodable {
    let url: String
    let title: String
    let byline: String
    let abstract: String
    let section: String
}

class ArticleViewModel: ObservableObject{
    
    
    func fetchData() async throws -> article{
        let endpoint = "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=ggLfIEY2AUVIfAV81Mef9gxo35CvDBjU"
        
        guard let url = URL(string: endpoint) else {
            throw wordError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw wordError.invalidNetwork
        }
        
        do{
            let decoder = JSONDecoder()
            let netResponse = try decoder.decode(ArticleResponse.self, from: data)
            let firstArticle = netResponse.results.first
            return firstArticle ?? article(url: "", title: "", byline: "", abstract: "", section: "")
            
        }catch{
            throw wordError.invalidData
        }
        
        
        
    }
}
