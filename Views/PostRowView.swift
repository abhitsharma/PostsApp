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
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("User ID: \(post.userId)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle()) // avoid row selection conflicts
        }
        .padding()
        .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.systemGray6))
                )
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

