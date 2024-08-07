//
//  Model.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import Foundation
import UIKit

// MARK: - UserNameResponse
struct UserNameResponse: Codable {
    let userNameStatus: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case userNameStatus = "UserNameStatus"
        case message
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    let status: Int
    let message: String
    let data: [Dataa]
}

// MARK: - Dataa
struct Dataa: Codable {
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatarUrl"
    }
}

// MARK: - RegisterProfile
struct RegisterProfile: Codable {
    let status: Int
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let name: String
    let avatar: String
    let username, isPurchase, link: String
    let selectedCardTitle: [String]
}
