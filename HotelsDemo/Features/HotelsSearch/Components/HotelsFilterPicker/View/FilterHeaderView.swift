//
//  FilterHeaderView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public class FilterHeaderView: NiblessView {
	private var hierarchyNotReady = true

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .semibold)
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
		addSubview(titleLabel)
	}

	private func activateConstraints() {
		activateConstraintsTitleLabel()
	}
}

// MARK: - Layout

extension FilterHeaderView {
	private func activateConstraintsTitleLabel() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		let leading = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
		let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = titleLabel.topAnchor.constraint(equalTo: topAnchor)
		let bottom = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}
