//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 29/03/2026.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
       //MARK: - Properties
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
       //MARK: - Behaviour
    private func addSubscribers(){
        dataService.$image
            .sink {[weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
