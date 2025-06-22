//
//  SearchCriteriaRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public class SearchCriteriaRootView: NiblessView {
	private var hierarchyNotReady = true

	lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			destinationButton,
			datesButton,
			roomGuestsButton
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let destinationButton: UIButton = {
		let button = UIButton(type: .system)
		button.tintColor = .darkText
		button.setTitle("destination", for: .normal)
		return button
	}()

	public let datesButton: UIButton = {
		let button = UIButton(type: .system)
		button.tintColor = .darkText
		button.setTitle("dates", for: .normal)
		return button
	}()

	public let roomGuestsButton: UIButton = {
		let button = UIButton(type: .system)
		button.tintColor = .darkText
		button.setTitle("room guests", for: .normal)
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
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension SearchCriteriaRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		NSLayoutConstraint.activate([leading, trailing, top])
	}
}
