//
//  FavouritesManager.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 09/12/2025.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "FavoritePlantIDs"
    
    // store id as a Set for fast lookup
    private var favorites: Set<String>
    
    private init() {
        // load existing favorites from disk
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            favorites = Set(saved)
        } else {
            favorites = []
        }
    }
    
    func isFavorite(id: String) -> Bool {
        return favorites.contains(id)
    }
    
    func toggleFavorite(id: String) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        save()
    }
    
    private func save() {
        // save back to UserDefaults
        UserDefaults.standard.set(Array(favorites), forKey: key)
    }
}
