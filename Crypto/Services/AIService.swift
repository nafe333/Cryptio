//
//  AIService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 19/04/2026.
//

import Foundation

class AIService {
    
    static let shared = AIService()
    private init() {}
    private let apiKey = "8499fbddd488e96b6947ca5fa0d6a89caec57f58fc8b830db130395f44ac85d6"
    
    func sendMessage(messages: [ChatMessage], completion: @escaping (String) -> Void) {
        
        guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("cryptio", forHTTPHeaderField: "HTTP-Referer")
        request.addValue("Cryptio", forHTTPHeaderField: "X-Title")
        
        let body: [String: Any] = [
            "model": "openai/gpt-3.5-turbo",
            "messages": messages.map {
                ["role": $0.role, "content": $0.content]
            }
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion("Network error")
                return
            }
            
            guard let data = data else {
                completion("No data")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                let reply = decoded.choices.first?.message.content ?? "No reply"
                completion(reply)
            } catch {
                completion("Failed to decode")
            }
            
        }.resume()
    }
}
