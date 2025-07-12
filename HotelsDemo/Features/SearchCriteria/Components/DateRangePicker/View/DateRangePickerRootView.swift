//
//  DateRangePickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

final class DateRangePickerRootView: NiblessView {
	private var hierarchyNotReady = true

	public lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			weekdaysCollectionView,
			collectionView,
			applyButtonView
		])
		stack.axis = .vertical
		stack.spacing = 8
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Select dates"
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.textColor = .label
		return label
	}()

	public let weekdaysCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0

		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: layout
		)
		collectionView.heightAnchor.constraint(equalToConstant: 34).isActive = true
		return collectionView
	}()

	public let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0

		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: layout
		)
		return collectionView
	}()

	private let applyButtonView: ActionButtonView = {
		let view = ActionButtonView()
		view.setTitle("Apply")
		view.button.isEnabled = false
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
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension DateRangePickerRootView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30)
		let bottom = stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
