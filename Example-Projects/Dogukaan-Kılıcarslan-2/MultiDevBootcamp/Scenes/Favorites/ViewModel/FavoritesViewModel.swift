//
//  FavoritesViewModel.swift
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    private let storage: NewsStorageProtocol
    
    @Published private(set) var favoriteArticles: [NewsArticle] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    init(storage: NewsStorageProtocol) {
        self.storage = storage
        // Preload from storage only
    }
    
    func refresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        // Load favorite articles directly from storage
        do {
            favoriteArticles = try storage.loadFavoriteArticles()
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load favorite articles: \(error)")
        }
    }
    
    func toggleFavorite(for article: NewsArticle) {
        // Toggle favorite status and reload favorites
        do {
            // Ensure article is saved first
            if !storage.isArticleSaved(article.url?.absoluteString ?? article.id) {
                try storage.saveArticles([article])
            }
            try storage.toggleFavorite(
                id: article.url?.absoluteString ?? article.id
            )
            // Refresh the list after toggling
            Task { await refresh() }
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to toggle favorite: \(error)")
        }
    }
    
    func isFavorite(_ article: NewsArticle) -> Bool {
        // Check if article is favorite
        storage.isFavorite(id: article.url?.absoluteString ?? article.id)
    }
    
    func isReadLater(_ article: NewsArticle) -> Bool {
        storage.isArticleSaved(article.url?.absoluteString ?? article.id)
    }
    
    func toggleReadLater(for article: NewsArticle) {
        do {
            try storage.toggleReadLater(id: article.url?.absoluteString ?? article.id)
            // Refresh the list after toggling
            Task { await refresh() }
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to toggle read later: \(error)")
        }
    }
}
