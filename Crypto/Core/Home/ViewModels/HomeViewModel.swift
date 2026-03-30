//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 23/03/2026.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    
       //MARK: - Properties
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "first title", value: "value 1", percentageChange: 54.2),
        StatisticModel(title: "second one", value: "value twoo"),
        StatisticModel(title: "third", value: "value trioo"),
        StatisticModel(title: "forth ", value: "fourthh", percentageChange: -12.4)
    ]
    
    init() {
addSubscribers()
    }
    
       //MARK: - Behaviour
    private func addSubscribers(){
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercased = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercased) ||
            coin.symbol.lowercased().contains(lowercased) ||
            coin.id.contains(lowercased)
        }
    }
    
}
