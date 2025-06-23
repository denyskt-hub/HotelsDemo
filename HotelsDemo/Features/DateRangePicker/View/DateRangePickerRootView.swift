//
//  DateRangePickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

final class DateRangePickerRootView: NiblessView {
	private var hierarchyNotReady = true

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
		addSubview(weekdaysCollectionView)
		addSubview(collectionView)
	}

	private func activateConstraints() {
		activateConstraintsWeekdaysCollectionView()
		activateConstraintsCollectionView()
	}
}

// MARK: - Layout

extension DateRangePickerRootView {
	private func activateConstraintsWeekdaysCollectionView() {
		weekdaysCollectionView.translatesAutoresizingMaskIntoConstraints = false
		let leading = weekdaysCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = weekdaysCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = weekdaysCollectionView.topAnchor.constraint(equalTo: topAnchor)
		let height = weekdaysCollectionView.heightAnchor.constraint(equalToConstant: 44)
		NSLayoutConstraint.activate([leading, trailing, top, height])
	}

	private func activateConstraintsCollectionView() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		let leading = collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = collectionView.topAnchor.constraint(equalTo: weekdaysCollectionView.bottomAnchor)
		let bottom = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
