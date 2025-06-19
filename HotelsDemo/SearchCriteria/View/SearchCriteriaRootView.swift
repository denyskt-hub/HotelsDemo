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
			destinationLabel,
			datesLabel,
			roomGuestsLabel
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let destinationLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .title1)
		label.textColor = .black
		label.setContentHuggingPriority(.defaultLow, for: .horizontal)
		return label
	}()

	public let datesLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .title1)
		label.textColor = .black
		label.backgroundColor = .systemGroupedBackground
		label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		return label
	}()

	public let roomGuestsLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .title1)
		label.textColor = .black
		return label
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
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
