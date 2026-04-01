# 🌟 Major iOS Applications

## 🎯 Overview
This directory contains my flagship iOS applications. These projects represent comprehensive, full-featured mobile applications built natively for iOS. They demonstrate my ability to design complex user interfaces, manage application state, integrate with Apple's core frameworks (like MapKit and Core Data), and structure code using the MVC (Model-View-Controller) design pattern.

---

## 📱 Featured Projects

### 1. [Ness Garden Visitor App](./NessGardenVisitorApp)
A location-aware digital tour guide designed to enhance the physical visitor experience at Ness Botanic Gardens. 

**Key Technical Highlights:**
* **Interactive Mapping (MapKit):** Parses and renders a local `.gpx` file to draw a custom walking route directly on the map.
* **Persistent Storage (Core Data):** Implements a robust local database allowing users to save their favorite plants and locations across app sessions.
* **Dynamic UI & Navigation:** Utilizes custom `UITableView` cells and modular View Controllers to present a searchable directory of garden highlights.
* **Tech Stack:** Swift 5, UIKit, MapKit, CoreLocation, Core Data.

### 2. [Mastermind Game](./mastermindGame)
A complete digital recreation of the classic code-breaking board game, "Mastermind." The player must crack a secret combination of colored balls within a limited number of attempts, receiving algorithmic feedback after each guess.

**Key Technical Highlights:**
* **Game Loop & State Management:** Handles complex win/loss conditions, guess validation, and tracks exact vs. partial matches.
* **Custom User Interface:** Features programmatic UI updates and custom `UITableViewCell` designs to maintain a visual log of the player's guess history.
* **Data Tracking:** Logs game history and winners using structured data models and dedicated View Controllers.
* **Tech Stack:** Swift 5, UIKit, Custom `.xcassets`.

---

## 🚀 How to Run
Both applications are completely self-contained Xcode projects. To run either app:
1. Navigate into the specific project folder.
2. Open the `.xcodeproj` file in **Xcode**.
3. Select an iOS Simulator (e.g., iPhone 14 Pro) from the run destination menu.
4. Press `Cmd + R` to build and run the application.

*(Note: For the Ness Garden app, you can simulate your GPS location in Xcode via `Features > Location` to fully test the map routing).*
