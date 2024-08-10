//
//  EditViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Foundation

class EditViewModel {
    // MARK: - Properties
    var cardTitles: [String] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchCardTitles() {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("Username not found in UserDefaults")
            return
        }
        
        APIService.shared.fetchCardTitles(username: username) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.cardTitles = titles
                self?.onDataUpdated?()
            case .failure(let error):
                self?.onError?("Error fetching card titles: \(error.localizedDescription)")
            }
        }
    }
}
