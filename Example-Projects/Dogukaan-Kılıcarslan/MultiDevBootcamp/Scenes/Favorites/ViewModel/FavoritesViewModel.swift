//
//  FavoritesViewModel.swift
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    private let storage: NewsStorage
    
    @Published private(set) var favoriteArticles: [NewsArticle] = []
    
    init(storage: NewsStorage) {
        self.storage = storage
        // Preload from storage only
    }
    
    func reload() {
        // Load all articles and filter to favorites
    }
    
    func toggleFavorite(for article: NewsArticle) {
        // Toggle favorite status and reload favorites
    }
    
    func isFavorite(_ article: NewsArticle) -> Bool {
        // Check if article is favorite
        return false
    }
}


