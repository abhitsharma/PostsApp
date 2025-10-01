//
//  PostRowView.swift
//  PostsApp
//
//  Created by Abhit Sharma on 01/10/25.
//

import SwiftUI

struct PostRowView: View {
    let post: Post
        let isFavorite: Bool
        let onFavoriteToggle: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(1)
                Text("User \(post.userId)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle()) // avoid row selection conflicts
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PostRowView(
        post: Post(
            userId: 1,
            id: 101,
            title: "Sample Post Title",
            body: "This is a sample body text for previewing how the row looks in SwiftUI.",
            isFavorite: false
        ),
        isFavorite: false,
        onFavoriteToggle: {}
    )
}

