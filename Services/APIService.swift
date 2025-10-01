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

final class APIService {
    static let shared = APIService()
    private init() {}
    
    private let postsURL = "https://jsonplaceholder.typicode.com/posts"
    
    /// Fetch posts using async/await; throws APIError
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: postsURL) else {
            throw APIError.invalidURL
        }
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.unknown(error)
        }
        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse(statusCode: -1)
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.badResponse(statusCode: http.statusCode)
        }
        do {
            let decoded = try JSONDecoder().decode([Post].self, from: data)
            return decoded
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
