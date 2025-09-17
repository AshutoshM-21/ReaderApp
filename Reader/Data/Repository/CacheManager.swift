//
//  CacheManager.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import Foundation
import CoreData

final class CacheManager {
    static let shared = CacheManager()
    private let context = CoreDataStack.shared.context

    private init() {}

    func saveArticles(_ articles: [Article]) {
        context.perform {
            let fetch: NSFetchRequest<NSFetchRequestResult> = CachedArticle.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            _ = try? self.context.execute(deleteRequest)

            for article in articles {
                let cached = CachedArticle(context: self.context)
                cached.title = article.title.isEmpty ? "No Title" : article.title
                cached.author = article.author.isEmpty ? "Unknown" : article.author
                cached.imageUrl = article.imageUrl
                cached.source = article.source.isEmpty ? "Unknown Source" : article.source
                cached.publishedAt = article.publishedAt
                cached.url = article.url
            }

            do {
                try self.context.save()
            } catch {
                debugPrint("Cache save failed:", error.localizedDescription)
            }
        }
    }

    func fetchArticles() -> [Article] {
        let fetch: NSFetchRequest<CachedArticle> = CachedArticle.fetchRequest()
        let results = (try? context.fetch(fetch)) ?? []
        return results.map {
            Article(
                title: $0.title ?? "No Title",
                author: $0.author ?? "Unknown",
                imageUrl: $0.imageUrl,
                source: $0.source ?? "Unknown Source",
                publishedAt: $0.publishedAt ?? "",
                url: $0.url ?? ""
            )
        }
    }
}
