//
//  PostsViewModel.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import Foundation
import Combine

@MainActor
final class PostsViewModel: ObservableObject {
    // UI-bound
    @Published private(set) var posts: [Post] = []        // filtered/current UI
    @Published var searchText: String = ""               // bound to TextField
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    // internal store
    private var allPosts: [Post] = []                    // source of truth from API
    private var cancellables = Set<AnyCancellable>()
    
    private let api = APIService.shared
    private let favoritesVM: FavoritesViewModel
    
    init(favoritesVM: FavoritesViewModel) {
        self.favoritesVM = favoritesVM
        bindFavorites()
        setupSearch()
    }
    
    // MARK: - Fetch
    func fetch() {
        Task {
            await fetchPosts()
        }
    }
    
    private func fetchPosts() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await api.fetchPosts()
            // Merge favorite state
            let updated = fetched.map { post -> Post in
                var p = post
                p.isFavorite = favoritesVM.isFavorite(post.id)
                return p
            }
            self.allPosts = updated
            applySearchAndPublish()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: - Search
    private func setupSearch() {
        // Use Combine to debounce the searchText and update `posts`
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.applySearchAndPublish()
                }
            }
            .store(in: &cancellables)
    }
    
    private func applySearchAndPublish() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            posts = allPosts
            return
        }
        let lower = searchText.lowercased()
        posts = allPosts.filter { $0.title.lowercased().contains(lower) }
    }
    
    // MARK: - Favorites integration
    private func bindFavorites() {
        // when favorites change, update local posts' isFavorite flags
        favoritesVM.$favorites
            .receive(on: RunLoop.main)
            .sink { [weak self] favorites in
                guard let self = self else { return }
                let favIds = Set(favorites.map { $0.id })
                self.allPosts = self.allPosts.map { post in
                    var p = post
                    p.isFavorite = favIds.contains(p.id)
                    return p
                }
                self.applySearchAndPublish()
            }
            .store(in: &cancellables)
    }
    
    // Toggle on a post — update favorites and local arrays immediately
    func toggleFavorite(_ post: Post) {
        // optimistic update locally
        if let idx = allPosts.firstIndex(where: { $0.id == post.id }) {
            var updated = allPosts[idx]
            updated.isFavorite.toggle()
            allPosts[idx] = updated
            applySearchAndPublish()
            // persist via favorites VM
            favoritesVM.toggleFavorite(updated)
        } else {
            // fallback: attempt to toggle via favoritesVM
            favoritesVM.toggleFavorite(post)
        }
    }
}

