//
//  UserExitsAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import Alamofire
import Foundation

protocol APIServiceProtocol {
    func checkUsername(username: String, completion: @escaping (Result<userNameResponse, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    func checkUsername(username: String, completion: @escaping (Result<userNameResponse, Error>) -> Void) {
        let parameters: [String: String] = [
            "username": username
        ]
        
        DispatchQueue.global(qos: .background).async {
            AF.request("https://lolcards.link/api/userExist", method: .post, parameters: parameters, encoding: URLEncoding.default).responseDecodable(of: userNameResponse.self) { response in
                switch response.result {
                case .success(let userNameResponse):
                    completion(.success(userNameResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

