//
//  RoomGuestsPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import UIKit

public class RoomGuestsPickerRootView: NiblessView {
	private var hierarchyNotReady = true

	public lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			roomsStepper,
			adultsStepper,
			childrenStepper,
			applyButton,
			spacer
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Select rooms and guests"
		return label
	}()

	public let roomsStepper: StepperView = {
		let stepper = StepperView()
		stepper.titleLabel.text = "Rooms"
		return stepper
	}()

	public let adultsStepper: StepperView = {
		let stepper = StepperView()
		stepper.titleLabel.text = "Adults"
		return stepper
	}()

	public let childrenStepper: StepperView = {
		let stepper = StepperView()
		stepper.titleLabel.text = "Children"
		return stepper
	}()

	public let applyButton: UIButton = {
		let button = UIButton()
		button.configure(.filled, title: "Apply")
		return button
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

extension RoomGuestsPickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
