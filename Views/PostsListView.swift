//
//  PostsListView.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import SwiftUI

struct PostsListView: View {
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var viewModel : PostsViewModel
    
    init() {
        let favVM = FavoritesViewModel()
        _favoritesVM = StateObject(wrappedValue: favVM)
        _viewModel = StateObject(wrappedValue: PostsViewModel(favoritesVM: favVM))
    }
    
    var body: some View {
        NavigationStack {
                   VStack {
                       // Search
                       TextField("Search posts...", text: $viewModel.searchText)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding()
                       
                       List(viewModel.posts) { post in
                           NavigationLink(destination: PostDetailView(post: post, favoritesVM: favoritesVM)) {
                               PostRowView(
                                   post: post,
                                   isFavorite: favoritesVM.isFavorite(post.id),
                                   onFavoriteToggle: {
                                       if favoritesVM.isFavorite(post.id) {
                                           favoritesVM.removeFavorite(id: post.id)
                                       } else {
                                           favoritesVM.addFavorite(post)
                                       }
                                   }
                               )
                           }
                       }
                   }
                   .navigationTitle("Posts")
                   .onAppear {
                       Task {
                              await viewModel.fetchPosts()
                              await favoritesVM.fetchFavorites()
                          }
                   }
               }
    }
}

#Preview {
    PostsListView()
}
