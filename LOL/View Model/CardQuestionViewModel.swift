//
//  CardTitleViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//


import Foundation

class CardQuestionViewModel {
    
    private let apiService: CardQuestionApiServiceProtocol
    
    var cardTitles: [String] = []
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(apiService: CardQuestionApiServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchCardTitles() {
        apiService.fetchCardTitle { [weak self] result in
            switch result {
            case .success(let selectedCardTitle):
                self?.cardTitles = selectedCardTitle.data.selectedCardTitle
                self?.reloadData?()
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            }
        }
    }
}
