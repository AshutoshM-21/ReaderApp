//
//  SearchViewController.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 17/09/25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search articles..."
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let tableView = UITableView()
    private var viewModel: ArticlesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
            titleLabel.text = "Search"
            titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            titleLabel.textColor = .label
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.hidesBackButton = true
          view.backgroundColor = .systemBackground
          
   
          let appearance = UINavigationBarAppearance()
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = .systemBackground
          appearance.shadowColor = nil
          
          navigationController?.navigationBar.standardAppearance = appearance
          navigationController?.navigationBar.scrollEdgeAppearance = appearance
          navigationController?.navigationBar.compactAppearance = appearance

          setupSearchBar()
          setupTableView()
        
        
        let repo = NewsAPIArticleRepository()
        viewModel = ArticlesViewModel(repository: repo)
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
    }
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    private func bindViewModel() {
        viewModel.onArticlesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onError = { error in
            print("Search error:", error.localizedDescription)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.fetchArticles(query: query)
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticleCell.reuseIdentifier,
            for: indexPath
        ) as? ArticleCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        let detailVC = ArticleDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
