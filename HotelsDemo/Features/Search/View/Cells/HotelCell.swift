//
//  HotelCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 13/7/25.
//

import UIKit

public final class HotelCell: UITableViewCell {
	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			photoImageView,
			infoStack
		])
		stack.axis = .horizontal
		stack.spacing = 10
		return stack
	}()

	public let photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .systemBlue
		imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		return imageView
	}()

	private lazy var infoStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			hotelInfoStack,
			roomInfoStack
		])
		stack.axis = .vertical
		stack.spacing = 8
		return stack
	}()

	private lazy var hotelInfoStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			nameLabel,
			starRatingView,
			reviewsView
		])
		stack.axis = .vertical
		stack.alignment = .leading
		stack.spacing = 8
		return stack
	}()

	public let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = .label
		return label
	}()

	private lazy var starRatingView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [])
		stack.axis = .horizontal
		stack.spacing = 2
		return stack
	}()

	private lazy var reviewsView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			scoreContainer,
			reviewsLabel,
			UIView()
		])
		stack.axis = .horizontal
		stack.spacing = 8
		return stack
	}()

	private let scoreContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray6
		return view
	}()

	public let scoreLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .label
		return label
	}()

	public let reviewsLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .secondaryLabel
		return label
	}()

	private lazy var roomInfoStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			priceLabel,
			priceDetailsLabel
		])
		stack.axis = .vertical
		stack.alignment = .trailing
		stack.spacing = 10
		return stack
	}()

	public let priceLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = .label
		return label
	}()

	public let priceDetailsLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .secondaryLabel
		return label
	}()

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public func prepareForReuse() {
		super.prepareForReuse()
		photoImageView.image = nil
	}

	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupHierarchy()
		activateConstraints()
	}

	private func setupHierarchy() {
		scoreContainer.addSubview(scoreLabel)
		contentView.addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsScoreLabel()
		activateConstraintsStack()
	}

	public func configure(with viewModel: SearchModels.HotelViewModel) {
		nameLabel.text = viewModel.name
		scoreLabel.text = viewModel.score
		reviewsLabel.text = viewModel.reviews
		setStarRating(viewModel.starRating)
		priceLabel.text = viewModel.price
		priceDetailsLabel.text = viewModel.priceDetails
	}

	private func setStarRating(_ rating: Int) {
		starRatingView.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		for _ in 0..<rating {
			let imageView = UIImageView()
			imageView.image = UIImage(systemName: "star.fill")
			imageView.contentMode = .scaleAspectFit
			imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
			imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
			starRatingView.addArrangedSubview(imageView)
		}
	}
}

// MARK: - Layout

extension HotelCell {
	private func activateConstraintsScoreLabel() {
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		let leading = scoreLabel.leadingAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.leadingAnchor)
		let trailing = scoreLabel.trailingAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.trailingAnchor)
		let top = scoreLabel.topAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.topAnchor)
		let bottom = scoreLabel.bottomAnchor.constraint(equalTo: scoreContainer.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}

	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
