//
//  WeekdayCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

final class WeekdayCell: UICollectionViewCell {
	public let label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		return label
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
		contentView.addSubview(label)
	}

	private func activateConstraints() {
		activateConstraintsLabel()
	}
}

// MARK: - Layout

extension WeekdayCell {
	private func activateConstraintsLabel() {
		label.translatesAutoresizingMaskIntoConstraints = false
		let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = label.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = label.topAnchor.constraint(equalTo: topAnchor)
		let bottom = label.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
