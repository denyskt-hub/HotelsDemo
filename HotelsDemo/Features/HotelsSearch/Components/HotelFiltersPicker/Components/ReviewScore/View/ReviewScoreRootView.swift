//
//  ReviewScoreRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public class ReviewScoreRootView: NiblessView {
	private var hierarchyNotReady = true

	public let tableView: UITableView = {
		let tableView = IntrinsicTableView()
		tableView.separatorStyle = .none
		tableView.allowsMultipleSelection = false
		tableView.showsVerticalScrollIndicator = false
		tableView.isScrollEnabled = false
		return tableView
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
	}

	private func activateConstraints() {
		activateConstraintsTableView()
	}
}

// MARK: - Layout

extension ReviewScoreRootView {
	private func activateConstraintsTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		let leading = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = tableView.topAnchor.constraint(equalTo: topAnchor)
		let bottom = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
