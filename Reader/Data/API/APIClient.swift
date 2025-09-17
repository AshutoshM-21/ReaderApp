//
//  APIClient.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let apiKey = Config.newsAPIKey
    
//    Articles
    func fetchArticles(query: String = "technology",completion: @escaping (Result<[Article],Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=\(query)"
        performRequest(urlString: urlString, completion: completion)
    }

//    category
    func fetchArticles(category: String,completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)"
        performRequest(urlString: urlString, completion: completion)
    }

    private func performRequest(urlString: String,completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2,
                                            userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                let mapped = decoded.articles.map {
                    Article(
                        title: $0.title ?? "No Title",
                        author: $0.author ?? "Unknown",
                        imageUrl: $0.urlToImage,
                        source: $0.source.name,
                        publishedAt: $0.publishedAt,
                        url: $0.url
                    )
                }
                completion(.success(mapped))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
