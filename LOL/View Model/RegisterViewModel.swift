//
//  RegisterViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 06/08/24.
//

import Foundation

class RegisterViewModel {
    private let apiService: RegisterAPIServiceProtocol
    var registerProfile: RegisterProfile?

    init(apiService: RegisterAPIServiceProtocol = RegisterAPIService.shared) {
        self.apiService = apiService
    }

    func registerUser(name: String, avatar: String, username: String, language: String, completion: @escaping (Result<RegisterProfile, Error>) -> Void) {

        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.registerUser(name: name, avatar: avatar, username: username, language: language) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.registerProfile = profile
                        print("ViewModel: Register Profile = \(profile)")
                        completion(.success(profile))
                    case .failure(let error):
                        print("ViewModel Error: \(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
