//
//  NewsListViewModel.swift
//

import Foundation

@MainActor
final class NewsListViewModel: ObservableObject {
    // Input dependencies (swap later):
    private let service: BasicNewsServiceProtocol
    private let storage: NewsStorageProtocol
    
    // UI state
    @Published private(set) var articles: [NewsArticle] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    init(service: BasicNewsServiceProtocol, storage: NewsStorageProtocol) {
        self.service = service
        self.storage = storage
        // Load cached articles initially
        self.articles = (try? storage.loadArticles()) ?? []
    }
    
    func refresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        // Refresh from network
        do {
            let result = try await service.fetchLatest(
                query: nil,
                page: 0,
                pageSize: 10
            )
            
            // Save articles to CoreData (preserving existing flags)
            try storage.saveArticles(result)
            
            // Reload articles from CoreData to get the correct flags
            articles = try storage.loadArticles()
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to fetch articles: \(error)")
        }
    }
    
    func toggleFavorite(for article: NewsArticle) {
        // First, ensure the article is saved to CoreData
        do {
            // Save the article if it doesn't exist
            if !storage.isArticleSaved(article.url?.absoluteString ?? article.id) {
                try storage.saveArticles([article])
            }
            // Toggle favorite status in storage
            try storage.toggleFavorite(
                id: article.url?.absoluteString ?? article.id
            )
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to toggle favorite: \(error)")
        }
        objectWillChange.send()
    }
    
    func toggleReadLater(for article: NewsArticle) {
        do {
            // First, save the article if it's not already in storage
            if !storage.isArticleSaved(article.url?.absoluteString ?? article.id) {
                try storage.saveArticles([article])
            }
            // Then toggle the read later status
            try storage.toggleReadLater(id: article.url?.absoluteString ?? article.id)
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to toggle read later: \(error)")
        }
        objectWillChange.send()
    }
    
    func isFavorite(_ article: NewsArticle) -> Bool {
        // Check if article is favorite
        storage.isFavorite(id: article.url?.absoluteString ?? article.id)
    }
    
    func isReadLater(_ article: NewsArticle) -> Bool {
        // Check if article is marked as read later
        storage.isArticleSaved(article.url?.absoluteString ?? article.id)
    }
}
