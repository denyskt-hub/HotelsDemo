//
//  AgePickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 10/7/25.
//

import UIKit

public class AgePickerRootView: NiblessView {
	private var hierarchyNotReady = true

	public lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			pickerView,
			doneButtonContainer
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.textColor = .label
		label.heightAnchor.constraint(equalToConstant: 28).isActive = true
		return label
	}()

	public let pickerView = UIPickerView()

	private let doneButtonContainer: UIView = {
		let view = UIView()
		return view
	}()

	public let doneButton: UIButton = {
		let button = UIButton()
		button.configure(.filled, title: "Done")
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
		doneButtonContainer.addSubview(doneButton)
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsDoneButton()
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension AgePickerRootView {
	private func activateConstraintsDoneButton() {
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		let leading = doneButton.leadingAnchor.constraint(equalTo: doneButtonContainer.layoutMarginsGuide.leadingAnchor)
		let trailing = doneButton.trailingAnchor.constraint(equalTo: doneButtonContainer.layoutMarginsGuide.trailingAnchor)
		let top = doneButton.topAnchor.constraint(equalTo: doneButtonContainer.layoutMarginsGuide.topAnchor)
		let bottom = doneButton.bottomAnchor.constraint(equalTo: doneButtonContainer.layoutMarginsGuide.bottomAnchor, constant: -10)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}

	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30)
		let bottom = stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
