//
//  UserDefaultsNewsStorage.swift
//  Implementation of UserDefaultsManager for NewsStorage
//

import Foundation

final class UserDefaultsNewsStorage: NewsStorage {
    // MARK: - Dependencies
    private let articlesManager: ArticlesDataManaging
    private let defaultsManager: UserDefaultsManager
    
    // MARK: - Keys
    // Stores favorite article ids as JSON-encoded array of String via UserDefaults
    private let favoritesKey: DefaultsCodableKey<[String]>
    
    init(defaults: UserDefaults = .standard, articlesManager: ArticlesDataManaging? = nil) {
        self.defaultsManager = UserDefaultsManager(defaults: defaults)
        // Allow injecting a custom articles manager; default to UserDefaults-backed one
        self.articlesManager = articlesManager ?? UserDefaultsArticlesDataManager(defaults: defaults)
        self.favoritesKey = DefaultsCodableKey<[String]>("news_favorites_v1", default: [])
    }
    
    // MARK: - Articles (delegated)
    func saveArticles(_ articles: [NewsArticle]) throws {
        try articlesManager.saveArticles(articles)
    }
    
    func loadArticles() throws -> [NewsArticle] {
        try articlesManager.loadArticles()
    }
    
    // MARK: - Favorites (ids only)
    func toggleFavorite(id: String) throws {
        var set = allFavoriteIDs()
        if set.contains(id) { set.remove(id) } else { set.insert(id) }
        try defaultsManager.setCodable(Array(set), forKey: favoritesKey)
    }
    
    func isFavorite(id: String) -> Bool {
        allFavoriteIDs().contains(id)
    }
    
    func allFavoriteIDs() -> Set<String> {
        let array: [String] = defaultsManager.codable(forKey: favoritesKey)
        return Set(array)
    }
}


