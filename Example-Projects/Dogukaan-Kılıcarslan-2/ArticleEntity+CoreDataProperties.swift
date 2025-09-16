//
//  ArticleEntity+CoreDataProperties.swift
//  MultiDevBootcamp
//
//  Created by dogukaan on 13.09.2025.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var articleImageUrl: String?
    @NSManaged public var articleUrl: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isReadLater: Bool
    @NSManaged public var publishedAt: Date?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?

}

extension ArticleEntity : Identifiable {

}
