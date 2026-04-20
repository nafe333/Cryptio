# Cryptio App 📊

This is a SwiftUI-based iOS app built using the MVVM architecture. It focuses on displaying real-time cryptocurrency data using the CoinGecko API and includes an AI chatbot feature using OpenRouter.

The app was built while following a Swiftful Thinking course, but I added extra features and structured parts of it differently to better fit real-world app development practices.

---

## What the app does

The main idea of the app is to track cryptocurrencies in real time and present the data in a clean and simple UI.

It also includes a chatbot where users can interact with an AI model for general questions or crypto-related discussions.

---

## Main features

- Live cryptocurrency prices and market data
- AI chatbot using OpenRouter API
- Reactive state handling with Combine
- Local persistence using Core Data and File manager
- Charts built with Swift Charts
- Smooth animations using Lottie
- MVVM architecture throughout the project

---

## Architecture

The project follows MVVM:

- **Models**: Data structures and API responses
- **Views**: SwiftUI screens and UI components
- **ViewModels**: Handles logic, API calls, and state management using Combine

The goal was to keep the views as clean as possible and move all logic into the ViewModels.

---

## APIs used

- CoinGecko API → for fetching crypto market data
- OpenRouter API → for the AI chatbot functionality

---

## Tech stack

- SwiftUI
- Combine
- MVVM Archetictural Pattern
- Core Data
- Swift Charts
- Lottie animations
- URLSession for networking

  ---

## What I focused on while building it

- Keeping a clean MVVM structure instead of mixing logic in views
- Reusing components wherever possible
- Handling asynchronous data properly with Combine
- Making the UI feel smooth and responsive
- Organizing the code in a scalable way

 ---
 
  ## Project structure

- Models
- Views
- ViewModels
- Services
- Managers
- Utilities
- Resources

  ---
  
## Notes

This project started as part of a learning course, but I used it as a base to experiment with architecture decisions, API handling, UI structure and animations.

It’s not just a tutorial project — I tried to treat it like a real app while building it.
