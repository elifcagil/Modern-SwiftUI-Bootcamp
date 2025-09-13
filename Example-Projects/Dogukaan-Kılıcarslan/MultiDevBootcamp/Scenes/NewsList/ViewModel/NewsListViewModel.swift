//
//  NewsListViewModel.swift
//

import Foundation

@MainActor
final class NewsListViewModel: ObservableObject {
    // Input dependencies (swap later):
    private let service: BasicNewsServiceProtocol
    private let storage: NewsStorage

    // UI state
    @Published private(set) var articles: [NewsArticle] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    init(service: BasicNewsServiceProtocol, storage: NewsStorage) {
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
    }

    func toggleFavorite(for article: NewsArticle) {
        // Toggle favorite status in storage
    }

    func isFavorite(_ article: NewsArticle) -> Bool {
        // Check if article is favorite
        return false
    }
}


