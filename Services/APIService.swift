//
//  APIService.swift
//  PostsApp
//
//  Created by Abhit Sharma on 30/09/25.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
}

class APIService {
    static let shared = APIService()

    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        return posts
    }
}
