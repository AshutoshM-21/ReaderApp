//
//  ArticlesViewController.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 15/09/25.
//


import UIKit

final class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var selectedCategory: NewsCategory = .general
    private var viewModel: ArticlesViewModel!
    private let category: NewsCategory
    private let tableView = UITableView()
    private let searchBar = ArticleSearchBar()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private var categoriesTopConstraint: NSLayoutConstraint!

    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    init(category: NewsCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = "Reader"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(openSearch)
        )

        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        view.addSubview(categoriesCollectionView)

        categoriesTopConstraint = categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        NSLayoutConstraint.activate([
            categoriesTopConstraint,
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])

        setupTableView()
        setupRefreshControl()
        setupLoadingIndicator()
        setupErrorLabel()

        let repo = NewsAPIArticleRepository()
        viewModel = ArticlesViewModel(repository: repo)
        bindViewModel()

        showLoading(true)
        viewModel.fetchArticles(category: selectedCategory)

        DispatchQueue.main.async {
            if let index = NewsCategory.allCases.firstIndex(of: .general) {
                self.selectedCategory = .general
                let indexPath = IndexPath(item: index, section: 0)
                self.categoriesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            }
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }

    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupErrorLabel() {
        errorLabel.text = "Something went wrong.\nPull to refresh."
        errorLabel.textAlignment = .center
        errorLabel.textColor = .secondaryLabel
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching latest news…")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func showLoading(_ show: Bool) {
        if show && !(tableView.refreshControl?.isRefreshing ?? false) {
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            errorLabel.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            tableView.isHidden = false
        }
    }

    private func showError(_ show: Bool) {
        errorLabel.isHidden = !show
        tableView.isHidden = show
    }

    private func bindViewModel() {
        viewModel.onArticlesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.showLoading(false)
                self?.showError(false)
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }

        viewModel.onError = { [weak self] _ in
            DispatchQueue.main.async {
                self?.showLoading(false)
                self?.showError(true)
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    @objc private func refreshData() {
        viewModel.fetchArticles(category: selectedCategory)
    }

    @objc private func openSearch() {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as? ArticleCell else {
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

    // MARK: - Scroll delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 50 {
            if categoriesTopConstraint.constant != -60 {
                categoriesTopConstraint.constant = -60
                UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
            }
        } else {
            if categoriesTopConstraint.constant != 16 {
                categoriesTopConstraint.constant = 16
                UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
            }
        }
    }
}

extension ArticlesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NewsCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCell else {
            return UICollectionViewCell()
        }

        let category = NewsCategory.allCases[indexPath.item]
        cell.configure(with: category)
        if category == selectedCategory {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = NewsCategory.allCases[indexPath.item]
        selectedCategory = category
        showLoading(true)
        viewModel.fetchArticles(category: category)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = NewsCategory.allCases[indexPath.item].displayName
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 24
        return CGSize(width: width, height: 32)
    }
}

extension ArticlesViewController: ArticleSearchBarDelegate {
    func didUpdateSearchQuery(_ query: String) {
        if query.isEmpty {
            viewModel.fetchArticles(category: selectedCategory)
        } else {
            viewModel.filterArticles(query: query)
        }
    }
}
