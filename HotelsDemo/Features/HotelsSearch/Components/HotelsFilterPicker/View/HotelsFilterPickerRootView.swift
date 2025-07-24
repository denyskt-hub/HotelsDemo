//
//  HotelsFilterPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import UIKit

public class HotelsFilterPickerRootView: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			tableView,
			applyButtonView
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.showsVerticalScrollIndicator = false
		return tableView
	}()

	private let applyButtonView: ActionButtonView = {
		let view = ActionButtonView()
		view.setTitle("Apply")
		return view
	}()

	public var applyButton: UIButton {
		applyButtonView.button
	}

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

extension HotelsFilterPickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
