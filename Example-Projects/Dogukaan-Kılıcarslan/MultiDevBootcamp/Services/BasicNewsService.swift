//
//  BasicNewsService.swift
//  Lesson 2: temporary simple network fetch without full network layer
//

import Foundation

protocol BasicNewsServiceProtocol {
    func fetchLatest(query: String?, page: Int, pageSize: Int) async throws -> [NewsArticle]
}

final class BasicNewsService: BasicNewsServiceProtocol {
    private let access: AccessProviderProtocol
    
    init(access: AccessProviderProtocol = AccessProvider()) {
        self.access = access
    }
    
    func fetchLatest(query: String?, page: Int, pageSize: Int) async throws -> [NewsArticle] {
        // If API key missing, return demo placeholders so the app still works in class
        guard let apiKey = access.apiKey(), !apiKey.isEmpty else {
            return (0..<3).map { idx in
                NewsArticle(
                    id: UUID().uuidString,
                    title: "Demo Article #\(idx + 1)",
                    description: "Provide NEWS_API_KEY to fetch real data.",
                    url: nil,
                    imageUrl: nil,
                    publishedAt: nil,
                    sourceName: "Demo"
                )
            }
        }
        
        var components = URLComponents(
            string: EndpointManager.BaseURL.main.rawValue + "/" + EndpointManager.Path.topHeadlines.rawValue
        )!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            // You can add more parameters like country, category, etc.
             URLQueryItem(name: "country", value: "us")
        ]
        if let q = query, !q.isEmpty { queryItems.append(URLQueryItem(name: "q", value: q)) }
        // Keep it simple for now; you can add more filters later
        components.queryItems = queryItems
        guard let url = components.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let payload = try decoder.decode(NewsDataResponse.self, from: data)
        let articles = payload.articles ?? []
        // Map to domain
        return articles.enumerated().map { index, item in
            NewsArticle(
                id: (item.url ?? UUID().uuidString) + "_\(index)",
                title: item.title ?? "Untitled",
                description: item.description,
                url: item.url.flatMap(URL.init(string:)),
                imageUrl: item.urlToImage.flatMap(URL.init(string:)),
                publishedAt: item.publishedAt,
                sourceName: item.source?.name
            )
        }
    }
}
