//
//  WeekdayCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

public final class WeekdayCell: UICollectionViewCell {
	public let label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		return label
	}()

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect = .zero) {
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
		let leading = label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
		let trailing = label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		let top = label.topAnchor.constraint(equalTo: contentView.topAnchor)
		let bottom = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
