//
//  DayCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

final class DateCell: UICollectionViewCell {
	public let button: UIButton = {
		let button = UIButton()
		button.configure(.plain)
		button.tintColor = .label
		return button
	}()

	required init?(coder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)

		setupHierarchy()
		activateConstraints()
	}

	private func setupHierarchy() {
		contentView.addSubview(button)
	}

	private func activateConstraints() {
		activateConstraintsButton()
	}

	public func configure(_ viewModel: DateRangePickerModels.CalendarDateViewModel) {
		button.setTitle(viewModel.date ?? "", for: .normal)
		button.tintColor = viewModel.isToday ? .blue : .label
	}
}

// MARK: - Layout

extension DateCell {
	private func activateConstraintsButton() {
		button.translatesAutoresizingMaskIntoConstraints = false
		let leading = button.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = button.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = button.topAnchor.constraint(equalTo: topAnchor)
		let bottom = button.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
