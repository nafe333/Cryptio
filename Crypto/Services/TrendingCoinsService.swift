//
//  TrendingCoinsService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 16/04/2026.
//

import Foundation
import Combine

class TrendingCoinsService {
    @Published var trendingCoins: [Item] = []
    var trendingCoinsSubscriber: AnyCancellable?
    
    init(){
        getTrendingCoins()
    }
    
       //MARK: - Behaviour
     func getTrendingCoins(){
        let urlString = "https://api.coingecko.com/api/v3/search/trending"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
         trendingCoinsSubscriber = NetworkingManager.download(url: URL(string: urlString)!)
            .decode(type: TrendingCoins.self, decoder: decoder)
            .map { response in
                response.coins?.compactMap { $0.item } ?? []
            }
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedDetails) in
                self? .trendingCoins = returnedDetails
                self?.trendingCoinsSubscriber?.cancel()
            })
    }
}
