//
//  NewsAPIModels.swift
//  Mirrors the request/response models used by NewsAPI
//

import Foundation

// MARK: - Request
struct NewsRequest: Codable {
    let query: String?
    let apiKey: String?
    let pageSize: Int?
    let page: Int?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case apiKey
        case pageSize
        case page
        case country
    }
}

// MARK: - Response Root
struct NewsDataResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}



