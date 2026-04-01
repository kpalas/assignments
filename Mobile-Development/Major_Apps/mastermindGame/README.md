# Mastermind iOS Game

## 🎯 Overview
A digital iOS recreation of the classic code-breaking board game, "Mastermind." The player must crack a secret combination of colored balls within a limited number of attempts, receiving feedback on exact and partial matches after each guess.

## 📱 Features
* **Interactive Gameplay:** Users can select and submit sequences of colored balls (Red, Blue, Green, Yellow, Orange, White).
* **Guess History:** Implemented a custom `UITableView` (`GuessHistoryTableViewCell`) to keep a visual log of previous guesses and their feedback (Black/White blobs for exact/partial matches).
* **Game State Management:** Tracks win/loss conditions and logs winners using `WinnersTableViewController`.

## 🛠️ Tech Stack
* **Language:** Swift 5
* **Framework:** UIKit
* **Architecture:** MVC (Model-View-Controller)
* **UI:** Storyboards (`Main.storyboard`) and custom `.xcassets` for visual elements.

## 🚀 How to Run
1. Clone this repository to your local machine.
2. Open `mastermindGame.xcodeproj` in **Xcode**.
3. Select an iOS Simulator (e.g., iPhone 14) from the run destination menu.
4. Press `Cmd + R` to build and run the application.
