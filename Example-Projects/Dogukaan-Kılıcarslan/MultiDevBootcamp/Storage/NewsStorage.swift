//
//  NewsStorage.swift
//  Abstraction for persisting and reading news data & favorites
//

import Foundation

// MARK: - Protocol the app talks to (to be pluggable in later lessons)
protocol NewsStorage {
    // Persist fetched articles (overwrite strategy) - to be implemented in lesson
    func saveArticles(_ articles: [NewsArticle]) throws

    // Load last saved articles
    func loadArticles() throws -> [NewsArticle]
    
    // Favorite ids API
    func toggleFavorite(id: String) throws
    func isFavorite(id: String) -> Bool
    func allFavoriteIDs() -> Set<String>
}
