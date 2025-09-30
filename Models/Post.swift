//
//  Post.swift
//  PostsApp
//
//  Created by Abhit Sharma on 30/09/25.
//

import Foundation

struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    var isFavorite: Bool = false
}

