//
//  UserExitsViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import Foundation

class UserNameViewModel {
    private let apiService: APIServiceProtocol
    
    var errorMessage: String? {
        didSet {
            DispatchQueue.main.async {
                self.bindViewModelToController()
            }
        }
    }
    
    var bindViewModelToController: (() -> ()) = {}
    var successCallback: (() -> ())?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func checkUsername(username: String) {
        apiService.checkUsername(username: username) { result in
            switch result {
            case .success(let userNameResponse):
                if userNameResponse.userNameStatus {
                    self.errorMessage = "* Username is already Exist"
                } else {
                    print("Username is Exist")
                    DispatchQueue.main.async {
                        self.successCallback?()
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
