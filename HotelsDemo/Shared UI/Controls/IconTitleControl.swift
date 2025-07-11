//
//  IconTitleControl.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 10/7/25.
//

import UIKit

public final class IconTitleControl: UIControl {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			imageView,
			titleLabel
		])
		stack.axis = .horizontal
		stack.alignment = .center
		stack.spacing = 8
		stack.isUserInteractionEnabled = false
		return stack
	}()

	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.setContentHuggingPriority(.required, for: .horizontal)
		imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
		imageView.tintColor = .label
		return imageView
	}()

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17)
		label.textColor = .label
		return label
	}()

	override public func didMoveToWindow() {
		super.didMoveToWindow()

		guard hierarchyNotReady else { return }

		setupHierarchy()
		activateConstraints()
		hierarchyNotReady = false
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

	public func setImage(_ image: UIImage?) {
		imageView.image = image
	}

	public func setSpacing(_ spacing: CGFloat) {
		stack.spacing = spacing
	}
}

// MARK: - Layout

extension IconTitleControl {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
