//
//  NewsAPIArticleRepository.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import Foundation

final class NewsAPIArticleRepository: ArticleRepository {
    private let client = APIClient.shared

    func fetchArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        client.fetchArticles(query: query) { result in
            switch result {
            case .success(let articles):
                CacheManager.shared.saveArticles(articles)
                completion(.success(articles))
            case .failure:
                let cached = CacheManager.shared.fetchArticles()
                if cached.isEmpty {
                    completion(.failure(
                        NSError(domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "No data available"]))
                    )
                } else {
                    completion(.success(cached))
                }
            }
        }
    }

    func fetchArticles(category: NewsCategory, completion: @escaping (Result<[Article], Error>) -> Void) {
        client.fetchArticles(category: category.rawValue) { result in
            switch result {
            case .success(let articles):
                CacheManager.shared.saveArticles(articles)
                completion(.success(articles))
            case .failure(let error):
                let cached = CacheManager.shared.fetchArticles()
                if cached.isEmpty {
                    completion(.failure(error))
                } else {
                    completion(.success(cached))
                }
            }
        }
    }
}

