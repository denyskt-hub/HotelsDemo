//
//  ChildAgeCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import UIKit

protocol AgeInputViewDelegate: AnyObject {
	func ageInputViewDidRequestPicker(_ view: AgeInputView, index: Int)
}

final class AgeInputView: NiblessView {
	private let viewModel: RoomGuestsPickerModels.AgeInputViewModel
	private var hierarchyNotReady = true

	public lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			selectButton
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		return label
	}()

	public let selectButton: UIButton = {
		let button = UIButton()
		button.configure(.plain)
		button.tintColor = .label
		return button
	}()

	public weak var delegate: AgeInputViewDelegate?

	public init(viewModel: RoomGuestsPickerModels.AgeInputViewModel) {
		self.viewModel = viewModel
		super.init(frame: .zero)

		configure(with: viewModel)
	}

	override public func didMoveToWindow() {
		super.didMoveToWindow()

		guard hierarchyNotReady else {
			return
		}

		setupAppearance()
		setupHierarchy()
		setupSelectButton()
		activateConstraints()
		hierarchyNotReady = false
	}

	private func setupAppearance() {
		backgroundColor = .systemBackground
	}

	private func setupHierarchy() {
		addSubview(stack)
	}

	private func setupSelectButton() {
		selectButton.addTarget(self, action: #selector(didRequestPicker), for: .touchUpInside)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}

	private func configure(with viewModel: RoomGuestsPickerModels.AgeInputViewModel) {
		titleLabel.text = viewModel.title
		selectButton.setTitle(viewModel.selectedAgeTitle, for: .normal)
	}

	@objc private func didRequestPicker() {
		delegate?.ageInputViewDidRequestPicker(self, index: viewModel.index)
	}
}

// MARK: - Layout

extension AgeInputView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
