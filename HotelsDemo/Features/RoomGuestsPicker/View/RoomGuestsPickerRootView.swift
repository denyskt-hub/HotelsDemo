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
			scrollView,
			applyButton
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Select rooms and guests"
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.textColor = .label
		return label
	}()

	public let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		return scrollView
	}()

	public lazy var contentStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			roomsStepper,
			adultsStepper,
			childrenStepper,
			childrenStack
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
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

	public let childrenStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let applyButton: UIButton = {
		let button = UIButton()
		button.configure(.filled, title: "Apply")
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
		scrollView.addSubview(contentStack)
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
		activateConstraintsContentStack()
	}
}

// MARK: - Layout

extension RoomGuestsPickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30)
		let bottom = stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}

	private func activateConstraintsContentStack() {
		contentStack.translatesAutoresizingMaskIntoConstraints = false
		let leading = contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
		let trailing = contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
		let top = contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
		let bottom = contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
		let width = contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom, width])
	}
}
