//
//  RegisterAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 06/08/24.
//

import Alamofire

protocol RegisterAPIServiceProtocol {
    func registerUser(name: String, avatar: String, username: String, language: String, completion: @escaping (Result<RegisterProfile, Error>) -> Void)
}

class RegisterAPIService: RegisterAPIServiceProtocol {
    static let shared = RegisterAPIService()
    
    private init() {}
    
    func registerUser(name: String, avatar: String, username: String, language: String, completion: @escaping (Result<RegisterProfile, Error>) -> Void) {
        let url = "https://lolcards.link/api/register"
        let parameters: [String: String] = [
            "name": name,
            "avatar": avatar,
            "username": username,
            "language": language
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: RegisterProfile.self) { response in
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(rawResponse)")
                }
                
                switch response.result {
                case .success(let data):
                    print("Decoded Response: \(data)")
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}
