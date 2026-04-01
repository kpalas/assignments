# 🌿 Ness Garden Visitor Guide & Interactive Map

## 🎯 Overview
The Ness Garden Visitor App is a location-aware iOS application designed to enhance the physical visitor experience at Ness Botanic Gardens. It serves as a digital tour guide, offering an interactive map with pre-defined walking routes, a searchable directory of garden highlights, and a persistent "Favorites" system so users can save plants and locations for later.

## 🌟 Key Features
* **Interactive GPX Routing:** Integrates **MapKit** to render a custom walking route directly on the map by parsing a local `.gpx` file (`NessWalk 25-Nov-2023 v2.gpx`).
* **Persistent Favorites System:** Uses **Core Data** (`CoreDataManager.swift`, `FavouritesManager.swift`) to save user preferences locally across app launches.
* **Dynamic Content Directory:** Implements `UITableView` with custom cells (`PlantCellTableViewCell`) to display detailed information about specific plants and locations within the garden.
* **Modular View Controllers:** The main view controller logic is broken down into Swift extensions (`ViewController+Map.swift`, `ViewController+TableView.swift`) to maintain clean, readable code and strict separation of concerns.

## 🛠️ Technical Stack & Architecture
* **Language:** Swift 5
* **UI Framework:** UIKit (Storyboards & Programmatic UI)
* **Local Storage:** Core Data
* **Location Services:** MapKit & CoreLocation
* **Design Pattern:** MVC (Model-View-Controller) with dedicated Manager classes for data handling.

## 🚀 How to Run
1. Clone this repository and navigate to the `NessGardenVisitorApp` directory.
2. Open `NessGardenVisitorApp.xcodeproj` in **Xcode**.
3. Select an iOS Simulator (e.g., iPhone 14 Pro).
4. *(Optional)* To test the location features accurately, simulate your location in Xcode by navigating to `Features > Location > Custom Location` and inputting the coordinates for Ness Gardens.
5. Press `Cmd + R` to build and run.

## 📸 Screenshots
