//
//  CandleChartDataService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 15/04/2026.
//

import Foundation
import Combine
class CandleChartDataService {
    
    private let coin: CoinModel
    @Published var candles: [[Double]] = []
    var candleChartSubscriber: AnyCancellable?
    private let baseUrl: String = "https://api.coingecko.com/api/v3/coins"
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinsChartData()
    }
    
       //MARK: - Behaviour
    func getCoinsChartData(){
            let urlString = "\(baseUrl)/\(coin.id)/ohlc?vs_currency=usd&days=7"
            
            candleChartSubscriber = NetworkingManager.download(url: URL(string: urlString)!)
                .decode(type: [[Double]].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: NetworkingManager.handleCompletion(completion:),
                    receiveValue: { [weak self] returnedData in
                        self?.candles = returnedData
                        self?.candleChartSubscriber?.cancel()
                    }
                )
        }
    
}
