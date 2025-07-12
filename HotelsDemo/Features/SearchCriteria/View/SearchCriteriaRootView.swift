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
			destinationControl,
			datesControl,
			roomGuestsControl,
			searchButton
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let destinationControl: IconTitleControl = {
		let control = IconTitleControl()
		control.setImage(UIImage(systemName: "magnifyingglass"))
		control.heightAnchor.constraint(equalToConstant: 44).isActive = true
		return control
	}()

	public let datesControl: IconTitleControl = {
		let control = IconTitleControl()
		control.setImage(UIImage(systemName: "calendar"))
		control.heightAnchor.constraint(equalToConstant: 44).isActive = true
		return control
	}()

	public let roomGuestsControl: IconTitleControl = {
		let control = IconTitleControl()
		control.setImage(UIImage(systemName: "person"))
		control.heightAnchor.constraint(equalToConstant: 44).isActive = true
		return control
	}()

	public let searchButton: UIButton = {
		let button = UIButton(type: .system)
		button.configure(.filled, title: "Search")
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
