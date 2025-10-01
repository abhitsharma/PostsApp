//
//  ContentView.swift
//  PostsApp
//
//  Created by Abhit Sharma on 30/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PostsListView()
                .tabItem {
                    Label("Posts", systemImage: "list.bullet")
                }
            
            FavoritesListView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
