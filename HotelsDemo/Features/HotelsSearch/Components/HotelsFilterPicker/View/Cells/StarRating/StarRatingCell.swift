//
//  StarRatingCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import UIKit

public final class StarRatingCell: UITableViewCell {
	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			iconImageView,
			starRatingContainer,
			UIView()
		])
		stack.axis = .horizontal
		stack.alignment = .fill
		stack.spacing = 4
		return stack
	}()

	private let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "square")
		imageView.highlightedImage = UIImage(systemName: "checkmark.square")
		return imageView
	}()

	private let starRatingContainer: UIView = {
		let view = UIView()
		return view
	}()

	private let starRatingView: StarRatingView = {
		let view = StarRatingView()
		return view
	}()

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupHierarchy()
		activateConstraints()
	}

	private func setupHierarchy() {
		starRatingContainer.addSubview(starRatingView)
		contentView.addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStarRatingView()
		activateConstraintsStack()
	}

	public func configure(with viewModel: HotelsFilterPickerModels.FilterOptionViewModel<Int>) {
		starRatingView.rating = viewModel.value
	}
}

// MARK: - Layout

extension StarRatingCell {
	private func activateConstraintsStarRatingView() {
		starRatingView.translatesAutoresizingMaskIntoConstraints = false
		let leading = starRatingView.leadingAnchor.constraint(equalTo: starRatingContainer.layoutMarginsGuide.leadingAnchor)
		let trailing = starRatingView.trailingAnchor.constraint(equalTo: starRatingContainer.layoutMarginsGuide.trailingAnchor)
		let centerY = starRatingView.centerYAnchor.constraint(equalTo: starRatingContainer.centerYAnchor)
		NSLayoutConstraint.activate([leading, trailing, centerY])
	}

	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
		let trailing = stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
		let top = stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
