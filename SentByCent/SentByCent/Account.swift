//
//  Account.swift
//  SentByCent
//
//  Created by Atif Mahmood on 3/8/25.
//

import Foundation

struct Account: Codable, Identifiable {
    let id: String
    let nickname: String
    let customer_id: String
    let account_number: String
    let balance: Double

    // Map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nickname, customer_id, account_number, balance
    }
}
// juststoring an account object, we'll need all this info
