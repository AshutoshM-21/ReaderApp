//
//  ArticleDetailViewController.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import UIKit
import WebKit

final class ArticleDetailViewController: UIViewController {
    private let article: Article
    private let webView = WKWebView()

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupWebView()
        loadArticle()
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = article.source
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareArticle)
        )

        let bookmarkImage = BookmarkManager.shared.isBookmarked(article)
            ? UIImage(systemName: "bookmark.fill")
            : UIImage(systemName: "bookmark")

        let bookmarkButton = UIBarButtonItem(
            image: bookmarkImage,
            style: .plain,
            target: self,
            action: #selector(toggleBookmark)
        )

        navigationItem.rightBarButtonItems = [shareButton, bookmarkButton]
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadArticle() {
        guard let url = URL(string: article.url) else { return }
        webView.load(URLRequest(url: url))
    }

    @objc private func shareArticle() {
        let activityVC = UIActivityViewController(
            activityItems: [article.url],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }

    @objc private func toggleBookmark() {
        if BookmarkManager.shared.isBookmarked(article) {
            BookmarkManager.shared.remove(article)
            navigationItem.rightBarButtonItems?.last?.image = UIImage(systemName: "bookmark")
            showToast("Removed from bookmarks")
        } else {
            BookmarkManager.shared.save(article)
            navigationItem.rightBarButtonItems?.last?.image = UIImage(systemName: "bookmark.fill")
            showToast("Added to bookmarks")
        }
    }

    private func showToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14, weight: .medium)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true

        view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
