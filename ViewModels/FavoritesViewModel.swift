//
//  FavoritesViewModel.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import Foundation
import CoreData
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Post] = []
    
    private let coreData = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // load initial favorites
        Task { await fetchFavorites() }
    }
    
    /// Fetch favorite Post objects from Core Data
    func fetchFavorites() async {
        let ctx = coreData.viewContext
        let req: NSFetchRequest<FavoritePostEntity> = FavoritePostEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(keyPath: \FavoritePostEntity.id, ascending: true)]
        do {
            let results = try ctx.fetch(req)
            self.favorites = results.map { ent in
                Post(userId: Int(ent.userId),
                     id: Int(ent.id),
                     title: ent.title ?? "",
                     body: ent.body ?? "",
                     isFavorite: true)
            }
        } catch {
            print("Failed to fetch favorites: \(error)")
            self.favorites = []
        }
    }
    
    /// Check if the post is favorited
    func isFavorite(_ id: Int) -> Bool {
        favorites.contains(where: { $0.id == id })
    }
    
    func addFavorite(_ post: Post) {
        let ctx = coreData.viewContext
        let request: NSFetchRequest<FavoritePostEntity> = FavoritePostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", post.id)
        let count = (try? ctx.count(for: request)) ?? 0
        if count > 0 { return }
        let entity = FavoritePostEntity(context: ctx)
        entity.id = Int64(post.id)
        entity.userId = Int64(post.userId)
        entity.title = post.title
        entity.body = post.body
        
        do {
            try ctx.save()
            Task { await fetchFavorites() }
        } catch {
            print("❌ Failed to save favorite: \(error)")
        }
    }


    
    /// Remove favorite by post id
    func removeFavorite(id: Int) {
        let ctx = coreData.viewContext
        let req: NSFetchRequest<FavoritePostEntity> = FavoritePostEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %d", id)
        do {
            let found = try ctx.fetch(req)
            found.forEach { ctx.delete($0) }
            coreData.saveContext()
            Task { await fetchFavorites() }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
    
    /// Toggle favorite state for a Post
    func toggleFavorite(_ post: Post) {
        Task {
            if isFavorite(post.id) {
                removeFavorite(id: post.id)
            } else {
                addFavorite(post)
            }
        }
    }

}
