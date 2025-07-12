//
//  SelectControl.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 10/7/25.
//

import UIKit

public final class SelectControl: UIControl {
	private var hierarchyNotReady = true

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17)
		label.textColor = .label
		return label
	}()

	private let arrowImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .systemGray
		imageView.setContentHuggingPriority(.required, for: .horizontal)
		return imageView
	}()

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			arrowImageView
		])
		stack.axis = .horizontal
		stack.alignment = .center
		stack.spacing = 8
		stack.isUserInteractionEnabled = false
		return stack
	}()

	public override func didMoveToWindow() {
		super.didMoveToWindow()
		guard hierarchyNotReady else { return }

		setupAppearance()
		setupHierarchy()
		activateConstraints()
		hierarchyNotReady = false
	}

	private func setupAppearance() {
		layer.borderWidth = 1
		layer.cornerRadius = 8
		layer.borderColor = UIColor.systemGray4.cgColor
		backgroundColor = .systemBackground
	}

	private func setupHierarchy() {
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}

	public func title() -> String? {
		titleLabel.text
	}

	public func setTitle(_ title: String?) {
		titleLabel.text = title
	}
}

// MARK: - Layout

extension SelectControl {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
