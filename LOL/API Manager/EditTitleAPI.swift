//
//  CardTitleAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Alamofire

class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func fetchCardTitles(username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let url = "https://lolcards.link/api/cardTitle"
        let parameters: [String: String] = ["username": username]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: CardTitle.self) { response in
                switch response.result {
                case .success(let cardTitleResponse):
                    completion(.success(cardTitleResponse.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
