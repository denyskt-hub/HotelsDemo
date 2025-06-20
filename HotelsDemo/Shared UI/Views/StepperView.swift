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

	private let decrementButton: UIButton = {
		let button = UIButton()
		button.setTitle("-", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
		button.setTitleColor(.label, for: .normal)
		return button
	}()

	private let incrementButton: UIButton = {
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

	enum StepperViewError: Error {
		case invalidRange
		case invalidStep
	}

	public func setRange(minimumValue: Int, maximumValue: Int) throws {
		guard minimumValue < maximumValue else {
			throw StepperViewError.invalidRange
		}
		self.minimumValue = minimumValue
		self.maximumValue = maximumValue
	}
	private var minimumValue: Int = 0
	private var maximumValue: Int = 100

	public func setStepValue(_ stepValue: Int) throws {
		guard stepValue > 0 else {
			throw StepperViewError.invalidStep
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
		setupDecrementButton()
		setupIncrementButton()
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

	private func setupDecrementButton() {
		decrementButton.addTarget(self, action: #selector(decrementValue), for: .touchUpInside)
	}

	private func setupIncrementButton() {
		incrementButton.addTarget(self, action: #selector(incrementValue), for: .touchUpInside)
	}

	@objc private func decrementValue() {
		setValue(value - stepValue)
	}

	@objc private func incrementValue() {
		setValue(value + stepValue)
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
