//
//  ReviewScoreRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public class ReviewScoreRootView: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			tableView
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.text = "Review Score"
		return label
	}()

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
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension ReviewScoreRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: topAnchor, constant: 10)
		let bottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
