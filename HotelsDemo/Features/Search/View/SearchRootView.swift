//
//  SearchRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public class SearchRootView: NiblessView {
	private var hierarchyNotReady = true

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
	}

	private func activateConstraints() {
	}
}

// MARK: - Layout

extension SearchRootView {
}
