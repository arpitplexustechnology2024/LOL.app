//
//  CardTitleAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Alamofire

class APIService {
    
    static let shared = APIService() // Singleton instance
    
    private init() {} // Private initializer to ensure only one instance is created
    
    // Function to fetch card titles
    func fetchCardTitles(username: String, completion: @escaping (Result<CardTitle, Error>) -> Void) {
        let parameters: [String: String] = ["username": username]
        
        AF.request("https://lolcards.link/api/findTitle", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: CardTitle.self) { response in
                switch response.result {
                case .success(let cardTitle):
                    completion(.success(cardTitle))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
