# 📍 My Favourite Places

## 🎯 Overview
"My Favourite Places" is a location-tracking iOS application that allows users to drop pins on a map and save their favorite geographical spots. It bridges native mapping capabilities with persistent local storage, ensuring that users' curated locations are always waiting for them when they reopen the app.

## 🌟 Key Features
* **Interactive Map:** Utilizes **MapKit** to display a navigable map where users can view and interact with specific locations.
* **Location Pinning:** Users can mark specific coordinates as "favorites."
* **Persistent Data:** Leverages **Core Data** (`My_Favourite_Places.xcdatamodeld`) to save pinned locations securely on the device, ensuring data survives app restarts.
* **List View Integration:** Displays saved locations in an easily readable format for quick navigation.

## 🛠️ Technical Stack
* **Language:** Swift 5
* **Frameworks:** UIKit, MapKit, CoreLocation
* **Database:** Core Data
* **Architecture:** MVC (Model-View-Controller)

## 🚀 How to Run
1. Open `My Favourite Places.xcodeproj` in Xcode.
2. Select an iOS Simulator (e.g., iPhone 14 Pro).
3. Press `Cmd + R` to build and run the application.
4. *Tip:* Use Xcode's location simulation feature (`Features > Location`) to spoof your GPS coordinates while testing the map.

## 📸 Screenshots
*(Add 1-2 screenshots of the map view with pins, and the list of saved places!)*
