//
//  CoreDataManager.swift
//  Skeleton aligned with NewsAPICase style
//
//  Notes:
//  - Uses an in-memory store by default so the app runs without a .xcdatamodeld file.
//  - Later in the lesson, point the container to a real model (ArticleEntity) and disk store.
//  - API mirrors NewsAPICase: saveContext, fetch, fetchWithPredicate, delete.
//

import Foundation
import CoreData

final class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    // Expose main context (later you can add background contexts as needed)
    let context: NSManagedObjectContext
    
    private init() {
        let container = CoreDataManager.makePersistentContainer()
        self.context = container.newBackgroundContext()
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.persistentContainer = container
    }
    
    // Keep a reference if you need to load stores again or create new contexts
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Persistent Container
    private static func makePersistentContainer() -> NSPersistentContainer {
        // Load the ArticleDatabase model
        guard let modelURL = Bundle.main.url(forResource: "ArticleDatabase", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to load ArticleDatabase model")
        }
        
        let container = NSPersistentContainer(name: "ArticleDatabase", managedObjectModel: model)
        
        // Configure for persistent storage
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(
            "ArticleDatabase.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.type = NSSQLiteStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent store: \(error), \(error.userInfo)")
            }
            print("CoreData store loaded at: \(storeDescription.url?.absoluteString ?? "unknown")")
        }
        
        // Enable automatic merging of changes from parent context
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }
    
    // MARK: - Saving
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            debugPrint("CoreData save error: \(error)")
        }
    }
    
    // MARK: - Fetching
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        do {
            if let fetched = try context.fetch(T.fetchRequest()) as? [T] { return fetched }
        } catch {
            debugPrint("Fetch error for \(type): \(error)")
        }
        return []
    }
    
    func fetchWithPredicate<T: NSManagedObject>(_ type: T.Type, predicateKey: String, predicateValue: String) -> [T]? {
        do {
            let request = T.fetchRequest()
            request.predicate = NSPredicate(format: "\(predicateKey) == %@", predicateValue)
            let fetched = try context.fetch(request) as? [T]
            return fetched
        } catch {
            debugPrint("Fetch (predicate) error for \(type): \(error)")
        }
        return nil
    }
    
    // MARK: - Deletion
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
