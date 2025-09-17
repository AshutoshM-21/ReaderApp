//
//  ArticleSearchBar.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import UIKit

protocol ArticleSearchBarDelegate: AnyObject {
    func didUpdateSearchQuery(_ query: String)
}

final class ArticleSearchBar: UIView {
    weak var delegate: ArticleSearchBarDelegate?

    private let searchController = UISearchController(searchResultsController: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchController()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchController()
    }

    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search articles"
        searchController.searchResultsUpdater = self
    }

    func attach(to navigationItem: UINavigationItem) {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension ArticleSearchBar: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        delegate?.didUpdateSearchQuery(query)
    }
}
