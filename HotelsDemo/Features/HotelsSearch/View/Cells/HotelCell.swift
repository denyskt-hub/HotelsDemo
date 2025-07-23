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
			photoContainer,
			infoStack
		])
		stack.axis = .horizontal
		stack.spacing = 10
		return stack
	}()

	public let photoContainer: UIView = {
		let view = UIView()
		view.roundAllCorners(radius: 10)
		return view
	}()

	public let photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .secondarySystemBackground
		imageView.tintColor = .secondaryLabel
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
		label.numberOfLines = 2
		return label
	}()

	private let starRatingView: StarRatingView = {
		let view = StarRatingView()
		return view
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

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func prepareForReuse() {
		super.prepareForReuse()
		photoImageView.image = nil
	}

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupHierarchy()
		activateConstraints()
	}

	private func setupHierarchy() {
		photoContainer.addSubview(photoImageView)
		scoreContainer.addSubview(scoreLabel)
		contentView.addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsPhotoImageView()
		activateConstraintsScoreLabel()
		activateConstraintsStack()
	}

	public func configure(with viewModel: HotelsSearchModels.HotelViewModel) {
		nameLabel.text = viewModel.name
		scoreLabel.text = viewModel.score
		reviewsLabel.text = viewModel.reviews
		starRatingView.rating = viewModel.starRating
		priceLabel.text = viewModel.price
		priceDetailsLabel.text = viewModel.priceDetails
		photoImageView.image = nil
	}
}

// MARK: - Layout

extension HotelCell {
	private func activateConstraintsPhotoImageView() {
		photoImageView.translatesAutoresizingMaskIntoConstraints = false
		let leading = photoImageView.leadingAnchor.constraint(equalTo: photoContainer.leadingAnchor)
		let trailing = photoImageView.trailingAnchor.constraint(equalTo: photoContainer.trailingAnchor)
		let top = photoImageView.topAnchor.constraint(equalTo: photoContainer.topAnchor)
		let bottom = photoImageView.bottomAnchor.constraint(equalTo: photoContainer.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}

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
