//
//  DestinationCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 8/7/25.
//

import UIKit

public final class DestinationCell: UITableViewCell {
	private let iconView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "mappin.and.ellipse")
		imageView.tintColor = .systemGray
		return imageView
	}()

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			subtitleLabel
		])
		stack.axis = .vertical
		stack.spacing = 2
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.textColor = .label
		label.numberOfLines = 1
		label.heightAnchor.constraint(equalToConstant: 21).isActive = true
		return label
	}()

	public let subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = .secondaryLabel
		label.numberOfLines = 1
		label.heightAnchor.constraint(equalToConstant: 21).isActive = true
		return label
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
		contentView.addSubview(iconView)
		contentView.addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsIconView()
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension DestinationCell {
	private func activateConstraintsIconView() {
		iconView.translatesAutoresizingMaskIntoConstraints = false
		let leading = iconView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
		let centerY = iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		let width = iconView.widthAnchor.constraint(equalToConstant: 24)
		let height = iconView.heightAnchor.constraint(equalToConstant: 24)
		NSLayoutConstraint.activate([leading, centerY, width, height])
	}

	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12)
		let trailing = stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
