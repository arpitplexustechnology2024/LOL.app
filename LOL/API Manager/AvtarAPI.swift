//
//  AvtarAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 02/08/24.
//

import Alamofire

class APIManager {
    static let shared = APIManager()

    private init() {}

    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }

    func fetchAvatars(completion: @escaping (Result<Avatar, Error>) -> Void) {
        let url = "https://lolcards.link/api/avatar"
        
        guard isConnectedToInternet() else {
            completion(.failure(NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"])))
            return
        }

        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .post).validate().responseDecodable(of: Avatar.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let avatarResponse):
                        completion(.success(avatarResponse))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
