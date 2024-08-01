//
//  Model.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import Foundation

// MARK: - Welcome
struct userNameResponse: Codable {
    let userNameStatus: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case userNameStatus = "UserNameStatus"
        case message
    }
}
