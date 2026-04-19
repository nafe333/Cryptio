//
//  HomeView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 21/03/2026.
//

import SwiftUI

struct HomeView: View {
       //MARK: - Properties
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var coinSelected: Bool = false
    @State private var currentPage: Int = 0
    @State private var showChat = false
    private let itemsPerPage = 5

       //MARK: - UI
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            VStack{
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                VStack(spacing: 8){
                    SearchBarView(searchText: $vm.searchText)
                }
                .padding(.vertical)
                columnTitles
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    ZStack {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            
                                portfolioEmptyView
                            
                        } else {
                            VStack(spacing: 8){
                                portfolioCoinsList
                                Spacer()
                                trendingCoinsList
                                
                            }
                        }
                    }
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .sheet(isPresented: $showChat) {
                NavigationStack {
                        ChatView()
                    }
            }
        }
        .background(
            // deprecated but wil be treated later on 
            NavigationLink(destination: LoadingDetailView(coin: $selectedCoin),
                       isActive: $coinSelected,
                       label: {
                           EmptyView()
                       })
        )
        .overlay(
            aiFloatingButton,
            alignment: .bottomTrailing
        )
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
    .navigationBarHidden(true)
    .environmentObject(HomeViewModel())
    
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none,value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimation(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.black)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }                }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 8))
                    .listRowBackground(Color.theme.background)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioEmptyView: some View {
        Text("You have no coins in your portfolio! \n Click the + Button to add some and get started 🫡")
            .font(.callout)
            .foregroundStyle(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 8))
                    .listRowBackground(Color.theme.background)

            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    // first one is the assigning one then the check
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                holdingsHeaderView
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
           priceHeaderView
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var holdingsHeaderView: some View {
        HStack(spacing: 4){
            Text("Holdings")
            Image(systemName: "chevron.down")
                .opacity(vm.sortOption == .holdings || vm.sortOption == .holdings ? 1.0 : 0.0)
                .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
        }
    }
    private var priceHeaderView: some View {
        HStack(spacing: 4){
            Text("Holdings")
            Image(systemName: "chevron.down")
                .opacity(vm.sortOption == .holdings || vm.sortOption == .holdings ? 1.0 : 0.0)
                .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
        }
    }
    
    private var trendingCoinsList: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Trending")
                .font(.headline)
                .padding(.horizontal)
            
            ZStack {
                
                HStack(spacing: 16) {
                    ForEach(pagedCoins) { coin in
                        VStack(spacing: 6) {
                            
                            RemoteImageView(urlString: coin.small)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            Text(coin.symbol?.uppercased() ?? "")
                                .font(.caption)
                                .fontWeight(.bold)
                                .lineLimit(1)
                            
                            
                            if let rank = coin.marketCapRank {
                                Text("#\(rank)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, (currentPage > 0 || currentPage < totalPages - 1) ? 50 : 16)
                if currentPage > 0 {
                    HStack {
                        Button {
                            withAnimation {
                                currentPage = max(currentPage - 1, 0)
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                //  Next button
                if currentPage < totalPages - 1 {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                currentPage = min(currentPage + 1, totalPages - 1)
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            .mask(
                HStack(spacing: 0) {
                    
                    //  Left fade
                    if currentPage > 0 && totalPages > 0 {
                        LinearGradient(
                            colors: [.clear, .black],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 40)
                    } else {
                        Color.black.frame(width: 0)
                    }
                    Color.black
                    
                    if currentPage < totalPages - 1 {
                        LinearGradient(
                            colors: [.black, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 40)
                    } else {
                        Color.black.frame(width: 0)
                    }
                }
            )
        }
        .onChange(of: vm.trendingCoins) { oldValue, newValue in
            currentPage = 0
        }
    }
    
    private var aiFloatingButton: some View {
        Button {
            showChat.toggle()
            
            
        } label: {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 56, height: 56)
                    .shadow(radius: 5)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
    
    private var sortedCoins: [Item] {
        vm.trendingCoins.sorted {
            ($0.marketCapRank ?? Int.max) < ($1.marketCapRank ?? Int.max)
        }
    }

    private var pagedCoins: [Item] {
        guard !sortedCoins.isEmpty else { return [] }
        
        let safePage = min(max(currentPage, 0), totalPages - 1)
        let start = safePage * itemsPerPage
        let end = min(start + itemsPerPage, sortedCoins.count)
        
        return start < end ? Array(sortedCoins[start..<end]) : []
    }

    private var totalPages: Int {
        (sortedCoins.count + itemsPerPage - 1) / itemsPerPage
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        coinSelected.toggle()
    }
}
