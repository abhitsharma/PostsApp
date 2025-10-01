//
//  PostDetailView.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
      @ObservedObject var favoritesVM: FavoritesViewModel
    var body: some View {
        ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(post.title)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            if favoritesVM.isFavorite(post.id) {
                                favoritesVM.removeFavorite(id: post.id)
                            } else {
                                favoritesVM.addFavorite(post)
                            }
                        } label: {
                            Image(systemName: favoritesVM.isFavorite(post.id) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                    
                    Text(post.body)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
            }
            .navigationTitle("Details")
    }
}

