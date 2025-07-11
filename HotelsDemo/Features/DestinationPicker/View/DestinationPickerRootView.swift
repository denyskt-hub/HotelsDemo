//
//  DestinationPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public class DestinationPickerRootView: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			textField,
			errorLabel,
			tableView
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Search destination"
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.textColor = .label
		return label
	}()

	public let textField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Destination"
		textField.borderStyle = .none
		textField.backgroundColor = .secondarySystemBackground
		textField.textColor = .label
		textField.font = .systemFont(ofSize: 16)
		textField.layer.cornerRadius = 8
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.systemGray4.cgColor
		textField.setLeftPaddingPoints(12)
		textField.setRightPaddingPoints(12)
		textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
		return textField
	}()

	public let errorContainer: UIView = {
		let view = UIView()
		return view
	}()

	public let errorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .secondaryLabel
		label.numberOfLines = 0
		return label
	}()

	public let tableView: UITableView = {
		let tableView = UITableView()
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

extension DestinationPickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30)
		let bottom = stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

extension UITextField {
	func setLeftPaddingPoints(_ amount: CGFloat) {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
		leftView = paddingView
		leftViewMode = .always
	}

	func setRightPaddingPoints(_ amount: CGFloat) {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
		rightView = paddingView
		rightViewMode = .always
	}
}
