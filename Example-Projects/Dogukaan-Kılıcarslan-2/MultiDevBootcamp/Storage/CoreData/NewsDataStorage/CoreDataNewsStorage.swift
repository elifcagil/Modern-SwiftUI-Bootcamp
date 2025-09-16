//
//  CoreDataNewsStorage.swift
//  Unified CoreData implementation for NewsStorageProtocol
//

import Foundation
import CoreData


/// TODO:  Optimize the article saved calls with a hash map inside the manager
///       check against the hash map instead of fetching the entity
final class CoreDataNewsStorage: NewsStorageProtocol {
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Articles
    func saveArticles(_ articles: [NewsArticle]) throws {
        let context = coreDataManager.context
        
        for article in articles {
            let articleId = article.url?.absoluteString ?? article.id
            
            // Check if article already exists
            if let existingEntity = fetchArticleEntity(byUrl: articleId) {
                // Update existing article, preserving favorite and read later flags
                print(
                    "Updating existing article: \(articleId), preserving flags - Favorite: \(existingEntity.isFavorite), ReadLater: \(existingEntity.isReadLater)"
                )
                updateArticleEntity(existingEntity, from: article, preserveFlags: true)
            } else {
                // Create new article with flags from the article object
                print(
                    "Creating new article: \(articleId) - Favorite: \(article.isFavorite), ReadLater: \(article.isReadLater)"
                )
                let entity = ArticleEntity(context: context)
                updateArticleEntity(entity, from: article, preserveFlags: false)
            }
        }
        
        coreDataManager.saveContext()
    }
    
    func loadArticles() throws -> [NewsArticle] {
        let entities = coreDataManager.fetch(ArticleEntity.self)
        return entities.map { mapToNewsArticle($0) }
    }
    
    // MARK: - Favorites
    func toggleFavorite(id: String) throws {
        guard let entity = fetchArticleEntity(byUrl: id) else {
            // If the article doesn't exist in CoreData, we can't toggle its favorite status
            print("Toggle Favorite failed: Article not found - \(id)")
            throw NewsStorageError.articleNotFound
        }
        
        let oldValue = entity.isFavorite
        entity.isFavorite = !oldValue
        print("Toggling favorite for \(id): \(oldValue) -> \(entity.isFavorite)")
        
        coreDataManager.saveContext()
    }
    
    func isFavorite(id: String) -> Bool {
        guard let entity = fetchArticleEntity(byUrl: id) else {
            return false
        }
        return entity.isFavorite
    }
    
    func allFavoriteIDs() -> Set<String> {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return Set(entities.compactMap { $0.articleUrl })
        } catch {
            print("Failed to fetch favorite IDs: \(error)")
            return []
        }
    }
    
    // MARK: - Read Later
    
    func isArticleSaved(_ id: String) -> Bool {
        guard let entity = fetchArticleEntity(byUrl: id) else {
            return false
        }
        return entity.isReadLater
    }
    
    func toggleReadLater(id: String) throws {
        guard let entity = fetchArticleEntity(byUrl: id) else {
            print("Toggle Read Later failed: Article not found - \(id)")
            throw NewsStorageError.articleNotFound
        }
        
        let oldValue = entity.isReadLater
        entity.isReadLater = !oldValue
        print("Toggling read later for \(id): \(oldValue) -> \(entity.isReadLater)")
        
        coreDataManager.saveContext()
    }
    
    func loadFavoriteArticles() throws -> [NewsArticle] {
        guard let entities = coreDataManager.fetchWithPredicate(
            ArticleEntity.self,
            predicateKey: "isFavorite",
            predicateValue: "1"
        ) else { return [] }
        
        return entities.compactMap {
            mapToNewsArticle(
                $0
            )
        }
    }
    
    func loadReadLaterArticles() throws -> [NewsArticle] {
        guard let entities = coreDataManager.fetchWithPredicate(
            ArticleEntity.self,
            predicateKey: "isReadLater",
            predicateValue: "1"
        ) else { return [] }
        return entities.compactMap {
            mapToNewsArticle($0)
        }
    }
    
    func deleteArticle(id: String) throws {
        guard let entity = fetchArticleEntity(byUrl: id) else {
            throw NewsStorageError.articleNotFound
        }
        coreDataManager.delete(entity)
    }
    
    // MARK: - Private Helpers
    private func fetchArticleEntity(byUrl url: String) -> ArticleEntity? {
        guard let entity = coreDataManager.fetchWithPredicate(
            ArticleEntity.self,
            predicateKey: "articleUrl",
            predicateValue: url
        )?.first else {
            return nil
        }
        return entity
    }
    
    private func updateArticleEntity(
        _ entity: ArticleEntity, from article: NewsArticle, preserveFlags: Bool = true
    ) {
        entity.title = article.title
        entity.articleDescription = article.description
        entity.articleUrl = article.url?.absoluteString ?? article.id
        entity.articleImageUrl = article.imageUrl?.absoluteString
        entity.publishedAt = article.publishedAt
        entity.sourceName = article.sourceName
        
        // Preserve existing flags unless explicitly set in the incoming article
        if !preserveFlags {
            entity.isFavorite = article.isFavorite
            entity.isReadLater = article.isReadLater
        }
        // If preserveFlags is true, we keep the existing values in CoreData
    }
    
    private func mapToNewsArticle(_ entity: ArticleEntity) -> NewsArticle {
        NewsArticle(
            id: entity.articleUrl ?? entity.objectID.description,
            title: entity.title ?? "",
            description: entity.articleDescription,
            url: URL(string: entity.articleUrl ?? ""),
            imageUrl: URL(string: entity.articleImageUrl ?? ""),
            publishedAt: entity.publishedAt,
            sourceName: entity.sourceName,
            isFavorite: entity.isFavorite,
            isReadLater: entity.isReadLater
        )
    }
}

// MARK: - Error Types
enum NewsStorageError: LocalizedError {
    case articleNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .articleNotFound:
            return "Article not found in storage"
        case .saveFailed(let error):
            return "Failed to save article: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch articles: \(error.localizedDescription)"
        }
    }
}
