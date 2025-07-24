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
			checkmarkImageView,
			starRatingContainer,
			UIView()
		])
		stack.axis = .horizontal
		stack.alignment = .fill
		stack.spacing = 10
		return stack
	}()

	private let checkmarkImageView: UIImageView = {
		let imageView = UIImageView()
		let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
		imageView.image = UIImage(systemName: "square", withConfiguration: config)
		imageView.highlightedImage = UIImage(systemName: "checkmark.square.fill", withConfiguration: config)
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

	public var onSelect: ((Int) -> Void)?

	public override func prepareForReuse() {
		super.prepareForReuse()
		onSelect = nil
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupHierarchy()
		setupGesture()
		activateConstraints()
	}

	private func setupHierarchy() {
		starRatingContainer.addSubview(starRatingView)
		contentView.addSubview(stack)
	}

	private func setupGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		contentView.addGestureRecognizer(tapGesture)
		contentView.isUserInteractionEnabled = true
	}

	private func activateConstraints() {
		activateConstraintsStarRatingView()
		activateConstraintsStack()
	}

	public func configure(with viewModel: HotelsFilterPickerModels.FilterOptionViewModel<StarRating>) {
		checkmarkImageView.isHighlighted = viewModel.isSelected
		starRatingView.rating = viewModel.value.rawValue
	}

	@objc private func handleTap() {
		checkmarkImageView.isHighlighted.toggle()
		onSelect?(starRatingView.rating)
	}
}

// MARK: - Layout

extension StarRatingCell {
	private func activateConstraintsStarRatingView() {
		starRatingView.translatesAutoresizingMaskIntoConstraints = false
		let leading = starRatingView.leadingAnchor.constraint(equalTo: starRatingContainer.leadingAnchor)
		let trailing = starRatingView.trailingAnchor.constraint(equalTo: starRatingContainer.trailingAnchor)
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
