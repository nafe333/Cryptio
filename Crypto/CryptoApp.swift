//
//  CryptoApp.swift
//  Crypto
//
//  Created by Nafea Elkassas on 21/03/2026.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationBarHidden(true)
            .environmentObject(vm)
        }
    }
}
