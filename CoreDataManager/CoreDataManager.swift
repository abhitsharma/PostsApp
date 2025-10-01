//
//  CoreDataManager.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PostsModel") // match .xcdatamodeld name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            } else {
                #if DEBUG
                print("Core Data loaded store at: \(desc.url?.absoluteString ?? "nil")")
                #endif
            }
        }
        // Optional: keep context changes automatically merged
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        let ctx = viewContext
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                print("CoreData save error: \(error)")
            }
        }
    }
}
