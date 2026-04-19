//
//  TrendingCoins.swift
//  Crypto
//
//  Created by Nafea Elkassas on 16/04/2026.
//

import Foundation
struct TrendingCoins: Codable {
    let coins: [Coin]?
}

struct Coin: Codable {
    let item: Item?
}

struct Item: Codable, Identifiable, Equatable {
    let id: String?
    let coinID: Int?
    let name, symbol: String?
    let marketCapRank: Int?
    let thumb, small, large: String?
    let score: Int?
}



