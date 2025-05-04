//
//  FavoritesManager.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 3.05.2025.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favorites: [ProductModel] = []
    
    private init() {}
    
    func isFavorite(_ product: ProductModel) -> Bool {
        return favorites.contains(where: { $0.id == product.id })
    }
    
    func addFavorite(_ product: ProductModel) {
        if !isFavorite(product) {
            favorites.append(product)
        }
    }
    
    func removeFavorite(_ product: ProductModel) {
        favorites.removeAll { $0.id == product.id }
    }
    
    func getFavorites() -> [ProductModel] {
        return favorites
    }
}
