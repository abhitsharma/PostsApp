//
//  FavoritesListView.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import SwiftUI

struct FavoritesListView: View {
    @StateObject private var favoritesVM = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            List(favoritesVM.favorites) { post in
                NavigationLink(destination: PostDetailView(post: post, favoritesVM: favoritesVM)) {
                    PostRowView(
                        post: post,
                        isFavorite: true, // already favorite
                        onFavoriteToggle: {
                            favoritesVM.removeFavorite(id: post.id)
                        }
                    )
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                Task{
                    await  favoritesVM.fetchFavorites()
                }
            }
        }
    }
}

#Preview {
    FavoritesListView()
}
