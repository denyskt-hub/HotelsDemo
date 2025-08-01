//
//  HotelsSearchRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public class HotelsSearchRootView: NiblessView {
	private var hierarchyNotReady = true

	public let tableView: UITableView = {
		let tableView = UITableView()
		return tableView
	}()

	public let actionBar: HotelsActionBar = {
		let actionBar = HotelsActionBar()
		return actionBar
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
		addSubview(tableView)
		addSubview(actionBar)
	}

	private func activateConstraints() {
		activateConstraintsTableView()
		activateConstraintsActionBar()
	}
}

// MARK: - Layout

extension HotelsSearchRootView {
	private func activateConstraintsTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		let leading = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
		let bottom = tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}

	private func activateConstraintsActionBar() {
		actionBar.translatesAutoresizingMaskIntoConstraints = false
		let leading = actionBar.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = actionBar.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let bottom = actionBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
		NSLayoutConstraint.activate([leading, trailing, bottom])
	}
}
