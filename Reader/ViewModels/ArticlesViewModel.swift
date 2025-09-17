//
//  ArticlesViewModel.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 15/09/25.
//

import Foundation

final class ArticlesViewModel {
    private let repository: ArticleRepository
    private(set) var articles: [Article] = []

    var onArticlesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func fetchArticles(query: String = "technology") {
        repository.fetchArticles(query: query) { [weak self] result in
            self?.handleResult(result)
        }
    }

    
    func fetchArticles(category: NewsCategory) {
        repository.fetchArticles(category: category) { [weak self] result in
            self?.handleResult(result)
        }
    }

    private func handleResult(_ result: Result<[Article], Error>) {
        switch result {
        case .success(let articles):
            self.articles = articles
            self.onArticlesUpdated?()
        case .failure(let error):
            self.articles = []
            self.onError?(error)
        }
    }

    
    func filterArticles(query: String) {
        articles = articles.filter { $0.title.lowercased().contains(query.lowercased()) }
        onArticlesUpdated?()
    }
}
