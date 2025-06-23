//
//  SectionHeaderView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/6/25.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
	static let reuseIdentifier = "SectionHeaderView"

	let label = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupHierarchy()
		activateConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupHierarchy() {
		addSubview(label)
	}

	private func activateConstraints() {
		activateConstraintsLabel()
	}
}

// MARK: - Layout

extension SectionHeaderView {
	private func activateConstraintsLabel() {
		label.translatesAutoresizingMaskIntoConstraints = false
		let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18)
		let trailing = label.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = label.topAnchor.constraint(equalTo: topAnchor)
		let bottom = label.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
