//
//  ArticlesDataManager.swift
//  Protocol-oriented manager dedicated to persisting NewsArticle objects
//

import Foundation

// MARK: - Protocol
/// Abstraction for reading/writing article objects regardless of underlying storage.
protocol ArticlesDataManaging {
    func saveArticles(_ articles: [NewsArticle]) throws
    func loadArticles() throws -> [NewsArticle]
}

// MARK: - Concrete UserDefaults-backed implementation
/// Stores article arrays using JSON via the shared UserDefaultsManager.
/// Keep it minimal for now; we'll extend in the lesson.
final class UserDefaultsArticlesDataManager: ArticlesDataManaging {
    private let defaultsManager: UserDefaultsManager
    private let articlesKey: DefaultsCodableKey<[NewsArticle]>

    init(defaults: UserDefaults = .standard) {
        self.defaultsManager = UserDefaultsManager(defaults: defaults)

        // set articlesKey
        self.articlesKey = DefaultsCodableKey<[NewsArticle]>("news_articles_v1", default: [])
    }

    func saveArticles(_ articles: [NewsArticle]) throws {
        // save articles array
    }

    func loadArticles() throws -> [NewsArticle] {
        // load articles array
        return []
    }
}


