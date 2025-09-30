//
//  APIService.swift
//  PostsApp
//
//  Created by Abhit Sharma on 30/09/25.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://jsonplaceholder.typicode.com/posts"
    
    private init() {}
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
