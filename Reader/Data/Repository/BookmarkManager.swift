//
//  BookmarkManager.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import CoreData

final class BookmarkManager {
    static let shared = BookmarkManager()
    private let context = CoreDataStack.shared.context

    private init() {}

    func save(_ article: Article) {
        let fetch: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetch.predicate = NSPredicate(format: "url == %@", article.url)

        if let result = try? context.fetch(fetch), !result.isEmpty {
            return 
        }

        let bookmark = Bookmark(context: context)
        bookmark.title = article.title
        bookmark.author = article.author
        bookmark.imageUrl = article.imageUrl
        bookmark.source = article.source
        bookmark.publishedAt = article.publishedAt
        bookmark.url = article.url

        CoreDataStack.shared.saveContext()
    }

    func remove(_ article: Article) {
        let fetch: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetch.predicate = NSPredicate(format: "url == %@", article.url)

        if let results = try? context.fetch(fetch) {
            results.forEach { context.delete($0) }
            CoreDataStack.shared.saveContext()
        }
    }

    func fetchAll() -> [Article] {
        let fetch: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        let results = (try? context.fetch(fetch)) ?? []
        return results.map {
            Article(title: $0.title ?? "",
                    author: $0.author ?? "",
                    imageUrl: $0.imageUrl,
                    source: $0.source ?? "",
                    publishedAt: $0.publishedAt ?? "",
                    url: $0.url ?? "")
        }
    }

    func isBookmarked(_ article: Article) -> Bool {
        let fetch: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetch.predicate = NSPredicate(format: "url == %@", article.url)
        let results = (try? context.fetch(fetch)) ?? []
        return !results.isEmpty
    }
}
