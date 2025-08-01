//
//  ReviewScoreCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/7/25.
//

import UIKit

public final class ReviewScoreCell: UITableViewCell {
	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			checkmarkImageView,
			titleLabel,
			UIView()
		])
		stack.axis = .horizontal
		stack.alignment = .fill
		stack.spacing = 10
		return stack
	}()

	public let checkmarkImageView: UIImageView = {
		let imageView = UIImageView()
		let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
		imageView.image = UIImage(systemName: "square", withConfiguration: config)
		imageView.highlightedImage = UIImage(systemName: "checkmark.square.fill", withConfiguration: config)
		return imageView
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		return label
	}()

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupAppearance()
		setupHierarchy()
		activateConstraints()
	}

	private func setupAppearance() {
		selectedBackgroundView = UIView()
	}

	private func setupHierarchy() {
		contentView.addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}

	public func configure(with viewModel: ReviewScoreModels.OptionViewModel) {
		checkmarkImageView.isHighlighted = viewModel.isSelected
		titleLabel.text = viewModel.title
	}
}

// MARK: - Layout

extension ReviewScoreCell {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
		let trailing = stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
		let top = stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
