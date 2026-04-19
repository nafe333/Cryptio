//
//  ChatModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 19/04/2026.
//

import Foundation
struct ChatMessage: Codable, Identifiable {
    var id = UUID()
    let role: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case role, content
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: ChatMessage
}
