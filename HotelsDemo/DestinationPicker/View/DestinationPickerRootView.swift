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
			spacer
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

	private let spacer: UIView = {
		let view = UIView()
		return view
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

extension DestinationPickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
