//
//  CandleModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 15/04/2026.
//

import Foundation
struct CandleModel: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    
    var isBullish: Bool {
        close >= open
    }
    
    static func from(_ data: [[Double]]) -> [CandleModel] {
            data.compactMap { item in
                guard item.count == 5 else { return nil }
                
                return CandleModel(
                    date: Date(timeIntervalSince1970: item[0] / 1000),
                    open: item[1],
                    high: item[2],
                    low: item[3],
                    close: item[4]
                )
            }
        }
}
