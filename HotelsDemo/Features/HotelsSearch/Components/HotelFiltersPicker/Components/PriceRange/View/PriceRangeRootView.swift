//
//  PriceRangeRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import UIKit

public class PriceRangeRootView: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			slider,
			selectedRangeStack
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.text = "Price Range"
		return label
	}()

	public let slider: RangeSlider = {
		let slider = RangeSlider()
		let height = slider.heightAnchor.constraint(equalToConstant: 30)
		height.priority = UILayoutPriority(999)
		height.isActive = true
		return slider
	}()

	private lazy var selectedRangeStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			lowerValueLabel,
			upperValueLabel
		])
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()

	public let lowerValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .medium)
		label.textColor = .secondaryLabel
		return label
	}()

	public let upperValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .medium)
		label.textColor = .secondaryLabel
		label.textAlignment = .right
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
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension PriceRangeRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: topAnchor, constant: 10)
		let bottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
