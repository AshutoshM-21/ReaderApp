//
//  ArticleRepository.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 15/09/25.
//

import Foundation

protocol ArticleRepository {
    func fetchArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void)
    func fetchArticles(category: NewsCategory, completion: @escaping (Result<[Article], Error>) -> Void)
}
