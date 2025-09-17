//
//  CategoryCell.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 17/09/25.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])

        applyTheme(selected: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: NewsCategory, isSelected: Bool = false) {
        titleLabel.text = category.displayName
        applyTheme(selected: isSelected)
    }

    private func applyTheme(selected: Bool) {
        if selected {
            contentView.backgroundColor = AppColors.accent
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = AppColors.cardBackground
            titleLabel.textColor = AppColors.navBarText
        }
    }

    override var isSelected: Bool {
        didSet { applyTheme(selected: isSelected) }
    }
}
