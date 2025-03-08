//
//  Purchase.swift
//  SentByCent
//
//  Created by Atif Mahmood on 3/8/25.
//

import Foundation

struct Purchase: Codable, Identifiable {
    let id: String
    let description: String
    let amount: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case description
        case amount
    }
}
