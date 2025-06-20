//
//  DestinationPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public class DestinationPickerRootView: NiblessView {
	private var hierarchyNotReady = true

	lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			title,
			textField,
			tableView
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let title: UILabel = {
		let label = UILabel()
		label.text = "Destination"
		return label
	}()

	public let textField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Destination"
		return textField
	}()

	public let tableView: UITableView = {
		let tableView = UITableView()
		return tableView
	}()

	public let errorContainer: UIView = {
		let view = UIView()
		return view
	}()

	public let errorLabel: UILabel = {
		let label = UILabel()
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
		errorContainer.addSubview(errorLabel)
	}

	private func activateConstraints() {
		activateConstraintsStack()
		activateConstraintsErrorLabel()
	}
}

// MARK: - Layout

extension DestinationPickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}

	private func activateConstraintsErrorLabel() {
		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		let leading = errorLabel.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor)
		let trailing = errorLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor)
		let top = errorLabel.topAnchor.constraint(equalTo: errorContainer.topAnchor)
		let bottom = errorLabel.bottomAnchor.constraint(equalTo: errorContainer.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
