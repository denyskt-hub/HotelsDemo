//
//  HotelFiltersPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public class HotelFiltersPickerRootView: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			scrollView,
			applyButtonView
		])
		stack.axis = .vertical
		stack.spacing = 10
		return stack
	}()

	public let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()

	public lazy var contentStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [])
		stack.axis = .vertical
		stack.spacing = 0
		return stack
	}()

	private let applyButtonView: ActionButtonView = {
		let view = ActionButtonView()
		view.setTitle("Apply")
		return view
	}()

	public var applyButton: UIButton {
		applyButtonView.button
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
		scrollView.addSubview(contentStack)
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsContentStack()
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension HotelFiltersPickerRootView {
	private func activateConstraintsContentStack() {
		contentStack.translatesAutoresizingMaskIntoConstraints = false
		let leading = contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
		let trailing = contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
		let top = contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
		let bottom = contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
		let width = contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom, width])
	}

	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
