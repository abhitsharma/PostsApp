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
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading posts...")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    // Error state
                    VStack(spacing: 16) {
                        Text("Failed to load posts")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            Task { await viewModel.fetchPosts() }
                        }) {
                            Text("Retry")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        TextField("Search posts...", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.top, 8)

                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.posts) { post in
                                    NavigationLink(
                                        destination: PostDetailView(post: post, favoritesVM: favoritesVM)
                                    ) {
                                        PostRowView(
                                            post: post,
                                            isFavorite: favoritesVM.isFavorite(post.id),
                                            onFavoriteToggle: { favoritesVM.toggleFavorite(post) }
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                        }
                        .refreshable {
                            await viewModel.fetchPosts()
                        }
                        .background(Color(.systemGroupedBackground))
                    }
                }
            }
            .navigationTitle("Posts")
        }
        .task {
            if viewModel.posts.isEmpty {
                await viewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    PostsListView()
}
