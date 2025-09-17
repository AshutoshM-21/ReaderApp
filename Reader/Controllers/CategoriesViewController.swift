//
//  CategoriesViewController.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import UIKit

final class CategoriesViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = CategoriesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Categories"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        view.addSubview(tableView)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = viewModel.categories[indexPath.row]
        cell.textLabel?.text = category.displayName
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = viewModel.categories[indexPath.row]
        let articlesVC = ArticlesViewController(category: category)
        navigationController?.pushViewController(articlesVC, animated: true)
    }
}
