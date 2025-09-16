//
//  ReadLaterViewModel.swift
//  MultiDevBootcamp
//
//  Created by dogukaan on 13.09.2025.
//

import Foundation

@MainActor
final class ReadLaterViewModel: ObservableObject {
    // Input dependencies (swap later):
    private let service: BasicNewsServiceProtocol
    private let storage: NewsStorageProtocol
    
    // UI state
    @Published private(set) var articles: [NewsArticle] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    init(
        service: BasicNewsServiceProtocol,
        storage: NewsStorageProtocol
    ) {
        self.service = service
        self.storage = storage
        // Load cached articles from coreData
    }
    
    func refresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        // Refresh read later articles from core data
        do {
            articles = try storage.loadReadLaterArticles()
        } catch {
            print("Failed to fetch read later articles: \(error)")
        }
    }
    
    func toggleFavorite(for article: NewsArticle) {
        // Toggle favorite status in storage
        do {
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
    
    func toggleReadLater(for article: NewsArticle) {
        do {
            // First, save the article if it's not already in storage
            if !storage.isArticleSaved(article.url?.absoluteString ?? article.id) {
                try storage.saveArticles([article])
            }
            // Then toggle the read later status
            try storage.toggleReadLater(id: article.url?.absoluteString ?? article.id)
            // Refresh the list after toggling
            Task { await refresh() }
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to toggle read later: \(error)")
        }
    }
    
    func isFavorite(_ article: NewsArticle) -> Bool {
        // Check if article is favorite
        storage.isFavorite(id: article.url?.absoluteString ?? article.id)
    }
    
    func isReadLater(_ article: NewsArticle) -> Bool {
        storage.isArticleSaved(article.url?.absoluteString ?? article.id)
    }
    
    func deleteArticle(_ article: NewsArticle) {
        do {
            try storage.deleteArticle(id: article.url?.absoluteString ?? article.id)
            // Refresh the list after deletion
            Task { await refresh() }
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to delete article: \(error)")
        }
    }
    
    func deleteAllReadLater() {
        for article in articles {
            deleteArticle(article)
        }
    }
}
