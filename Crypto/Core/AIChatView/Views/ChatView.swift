//
//  ChatView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 19/04/2026.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm = ChatViewModel()
    @State private var text = ""
    @Environment(\.dismiss) var dismiss
    let systemMessage = ChatMessage(
        role: "system",
        content: "You are a crypto assistant. Answer only crypto-related questions clearly and concisely."
    )
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    if vm.messages.isEmpty {
                        Text("No messages yet. Start the conversation!")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        bubbleMessageView
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }
                }
            
                .onChange(of: vm.messages.count) {_, _ in
                    if let last = vm.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("Suggestions:")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                    .opacity(0.5)
                
                suggestionsView
                    .padding(.horizontal)
                    .padding(.top, 4)
                    .padding(.bottom, 12)
            }
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: vm.suggestions)
            
            // If i need to add text field for customers to talk with AI directly
//            HStack {
//                TextField("Ask anything...", text: $text)
//                Button("Send") {
//                    
//                    vm.send(text)
//                    text = ""
//                }
//                .disabled(text.trimmingCharacters(in:  .whitespacesAndNewlines).isEmpty ? true : false)
//            }
//            .padding()
        }
        .navigationTitle("Cryptio Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                XMarkButton(dismiss: _dismiss)
            }
        })
    }
    private func sendSuggestion(_ text: String) {
        vm.send(text)
    }
}

#Preview {
    ChatView()
}
extension ChatView {
    private var bubbleMessageView: some View {
        ForEach(vm.messages) { msg in
            HStack {
                if msg.role == "user" { Spacer() }
                
                Text(msg.content)
                    .padding()
                    .background(msg.role == "user" ? Color.blue : Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                if msg.role == "assistant" { Spacer() }
            }
            .id(msg.id)
        }
        
    }
    
    private var suggestionsView: some View {
        VStack(spacing: 10) {
            ForEach(Array(vm.suggestions.enumerated()), id: \.element) { index, suggestion in
                Button {
                    sendSuggestion(suggestion)
                } label: {
                    HStack {
                        Text(suggestion)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.8)
                    .delay(Double(index) * 0.05),
                    value: vm.suggestions
                )
            }
        }
        .padding(.horizontal)
    }
}
