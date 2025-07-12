//
//  ActionButtonView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11/7/25.
//

import UIKit

public final class ActionButtonView: NiblessView {
	private var hierarchyNotReady = true

	public let button: UIButton = {
		let button = UIButton()
		button.configure(.filled)
		button.heightAnchor.constraint(equalToConstant: 48).isActive = true
		return button
	}()

	override public func didMoveToWindow() {
		super.didMoveToWindow()

		guard hierarchyNotReady else {
			return
		}

		setupAppearance()
		setupHierarchy()
		activateConstraints()
		hierarchyNotReady = false
	}

	private func setupAppearance() {
		backgroundColor = .systemBackground
	}

	private func setupHierarchy() {
		addSubview(button)
	}

	private func activateConstraints() {
		activateConstraintsButton()
	}

	public func setTitle(_ text: String?) {
		button.setTitle(text, for: .normal)
	}
}

// MARK: - Layout

extension ActionButtonView {
	private func activateConstraintsButton() {
		button.translatesAutoresizingMaskIntoConstraints = false
		let leading = button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = button.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
