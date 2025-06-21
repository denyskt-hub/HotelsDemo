//
//  StepperView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import UIKit

public class StepperView: NiblessView {
	private var hierarchyNotReady = true

	lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			stepperStack
		])
		stack.axis = .horizontal
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = .label
		label.text = "Title"
		return label
	}()

	private lazy var stepperStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			decrementButton,
			valueLabel,
			incrementButton
		])
		stack.axis = .horizontal
		stack.spacing = 10
		return stack
	}()

	public let decrementButton: UIButton = {
		let button = UIButton()
		button.setTitle("-", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
		button.setTitleColor(.label, for: .normal)
		return button
	}()

	public let incrementButton: UIButton = {
		let button = UIButton()
		button.setTitle("+", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
		button.setTitleColor(.label, for: .normal)
		return button
	}()

	private let valueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = .label
		label.text = "0"
		return label
	}()

	public func setRange(minimumValue: Int, maximumValue: Int) {
		guard minimumValue < maximumValue else {
			preconditionFailure("minimumValue must be < maximumValue")
		}
		self.minimumValue = minimumValue
		self.maximumValue = maximumValue
	}
	private var minimumValue: Int = 0
	private var maximumValue: Int = 100

	public func setStepValue(_ stepValue: Int) {
		guard stepValue > 0 else {
			preconditionFailure("stepValue must be > 0")
		}
		self.stepValue = stepValue
	}
	private var stepValue: Int = 1

	public func setValue(_ value: Int) {
		self.value = min(max(value, minimumValue), maximumValue)
	}
	private var value: Int = 0 {
		didSet {
			valueLabel.text = "\(value)"
			decrementButton.isEnabled = value > minimumValue
			incrementButton.isEnabled = value < maximumValue
		}
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

extension StepperView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
