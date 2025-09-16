//
//  NewsStorageProtocol.swift
//  Abstraction for persisting and reading news data & favorites
//

import Foundation

// MARK: - Protocol the app talks to (to be pluggable in later lessons)
protocol NewsStorageProtocol {
    // Persist fetched articles (overwrite strategy) - to be implemented in lesson
    func saveArticles(_ articles: [NewsArticle]) throws
    
    // Load last saved articles
    func loadArticles() throws -> [NewsArticle]
    
    // Favorite ids API
    func toggleFavorite(id: String) throws
    func isFavorite(id: String) -> Bool
    func allFavoriteIDs() -> Set<String>
    
    // Read Later API
    func toggleReadLater(id: String) throws
    
    // Check if article exists in storage
    func isArticleSaved(_ id: String) -> Bool
    
    // Filtered loading methods
    func loadFavoriteArticles() throws -> [NewsArticle]
    func loadReadLaterArticles() throws -> [NewsArticle]
    
    // Delete article
    func deleteArticle(id: String) throws
}
