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
			applyButtonContainer
		])
		stack.axis = .vertical
		stack.spacing = 0
		return stack
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Select dates"
		return label
	}()

	public let weekdaysCollectionView: UICollectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: UICollectionViewFlowLayout.calendarLayout
		)
		return collectionView
	}()

	public let collectionView: UICollectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: UICollectionViewFlowLayout.calendarLayout
		)
		return collectionView
	}()

	public let applyButtonContainer: UIView = {
		let view = UIView()
		return view
	}()

	public let applyButton: UIButton = {
		let button = UIButton()
		button.configure(.filled, title: "Apply")
		button.isEnabled = false
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
		applyButtonContainer.addSubview(applyButton)
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsApplyButton()
		activateConstraintsWeekdaysCollectionView()
		activateConstraintsStack()
	}
}

// MARK: - Layout

extension DateRangePickerRootView {
	private func activateConstraintsApplyButton() {
		applyButton.translatesAutoresizingMaskIntoConstraints = false
		let leading = applyButton.leadingAnchor.constraint(equalTo: applyButtonContainer.layoutMarginsGuide.leadingAnchor)
		let trailing = applyButton.trailingAnchor.constraint(equalTo: applyButtonContainer.layoutMarginsGuide.trailingAnchor)
		let top = applyButton.topAnchor.constraint(equalTo: applyButtonContainer.layoutMarginsGuide.topAnchor)
		let bottom = applyButton.bottomAnchor.constraint(equalTo: applyButtonContainer.layoutMarginsGuide.bottomAnchor)
		let height = applyButton.heightAnchor.constraint(equalToConstant: 44)
		NSLayoutConstraint.activate([leading, trailing, top, bottom, height])
	}

	private func activateConstraintsWeekdaysCollectionView() {
		weekdaysCollectionView.translatesAutoresizingMaskIntoConstraints = false
		let height = weekdaysCollectionView.heightAnchor.constraint(equalToConstant: 44)
		NSLayoutConstraint.activate([height])
	}

	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

extension UICollectionViewFlowLayout {
	static var calendarLayout: UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 4

		let numberOfColumns = CGFloat(7)
		let availableWidth = UIScreen.main.bounds.width
		let itemWidth = floor(availableWidth / numberOfColumns)
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		return layout
	}
}
