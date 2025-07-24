//
//  HotelsActionBar.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public class HotelsActionBar: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			filterButton
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let filterButton: UIButton = {
		let button = UIButton()
		button.configure(.filled, title: "Filter")
		button.roundAllCorners(radius: 10)
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
		backgroundColor = .clear
	}

	private func setupHierarchy() {
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension HotelsActionBar {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
