//
//  ListPlaceholderView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 08.08.2026.
//

import UIKit

/// Shown in place of a list: the message for the state the list is in and,
/// when that state is recoverable, the action that gets the user out of it.
/// An empty result is a dead end by nature; a failed load is not, and must
/// never leave the user on a blank screen with no way forward.
public final class ListPlaceholderView: NiblessView {
	private var hierarchyNotReady = true

	public let messageLabel: UILabel = {
		let label = UILabel()
		label.textColor = .secondaryLabel
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = .preferredFont(forTextStyle: .body)
		label.adjustsFontForContentSizeCategory = true
		return label
	}()

	public let actionButton: UIButton = {
		let button = UIButton()
		button.configure(.plain)
		button.isHidden = true
		return button
	}()

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [messageLabel, actionButton])
		stack.axis = .vertical
		stack.spacing = 8
		stack.alignment = .center
		return stack
	}()

	override public func didMoveToWindow() {
		super.didMoveToWindow()

		guard hierarchyNotReady else {
			return
		}

		setupHierarchy()
		activateConstraints()
		hierarchyNotReady = false
	}

	/// - Parameter actionTitle: `nil` for a state the user cannot act on.
	public func display(message: String, actionTitle: String? = nil) {
		messageLabel.text = message
		actionButton.configure(.plain, title: actionTitle)
		actionButton.isHidden = actionTitle == nil
	}

	private func setupHierarchy() {
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension ListPlaceholderView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let centerY = stack.centerYAnchor.constraint(equalTo: centerYAnchor)
		NSLayoutConstraint.activate([leading, trailing, centerY])
	}
}
