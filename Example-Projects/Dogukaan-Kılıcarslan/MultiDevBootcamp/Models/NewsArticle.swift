//
//  NewsArticle.swift
//  MultiDevBootcamp
//
//  Skeleton model for Lesson 2
//

import Foundation

// MARK: - Domain model for a news item
struct NewsArticle: Identifiable, Codable, Equatable {
    // Unique id for list diffing and favorites
    let id: String
    let title: String
    let description: String?
    let url: URL?
    let imageUrl: URL?
    let publishedAt: Date?
    let sourceName: String?
    var isFavorite: Bool = false // not from API, managed locally
}

// MARK: - API mapping scaffolding
// Adjust CodingKeys according to your API later
extension NewsArticle {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case url
        case imageUrl = "urlToImage"
        case publishedAt
        case sourceName
    }
}

// MARK: - Placeholder fixtures for preview/testing
extension NewsArticle {
    static let placeholder = NewsArticle(
        id: UUID().uuidString,
        title: "Placeholder Title",
        description: "Short description to show in list",
        url: URL(string: "https://example.com"),
        imageUrl: nil,
        publishedAt: nil,
        sourceName: "Example"
    )
}



