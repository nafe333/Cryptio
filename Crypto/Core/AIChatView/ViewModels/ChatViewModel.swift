//
//  ChatViewModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 19/04/2026.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var suggestions: [String] = [
        "What is Bitcoin?",
        "Explain Ethereum",
        "Top trending coins",
        "What is market cap?"
    ]
    
    func send(_ text: String) {
        let userMessage = ChatMessage(role: "user", content: text)
        messages.append(userMessage)
        
        isLoading = true
        
        // 👇 Update suggestions immediately (before AI responds)
        updateSuggestions(for: text)
        
        let systemMessage = ChatMessage(
            role: "system",
            content: """
            You are a crypto assistant inside a trading app.
            Rules:
            - Only answer crypto, finance, and trading related questions.
            - If user asks unrelated questions, respond: "I only answer crypto-related questions."
            - Be concise and practical.
            """
        )
        
        let fullMessages = [systemMessage] + messages
        
        AIService.shared.sendMessage(messages: fullMessages) { [weak self] reply in
            DispatchQueue.main.async {
                self?.messages.append(
                    ChatMessage(role: "assistant", content: reply)
                )
                self?.isLoading = false
            }
        }
    }
    
    private func updateSuggestions(for input: String) {
        let lower = input.lowercased()
        
        let newSuggestions: [String]
        
        if lower.contains("bitcoin") {
            newSuggestions = [
                "Is Bitcoin a good investment?",
                "Why is Bitcoin valuable?",
                "Bitcoin vs Ethereum",
                "What affects BTC price?"
            ]
        } else {
            newSuggestions = [
                "Top trending coins",
                "Best coins to watch",
                "Explain crypto basics",
                "How to start investing?"
            ]
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.suggestions = newSuggestions
            }
        }
    }
}
