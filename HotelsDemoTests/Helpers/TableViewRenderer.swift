//
//  TableViewRenderer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 31/7/25.
//

import UIKit

@MainActor
protocol TableViewRenderer: ListItemsRenderer {
	var tableView: UITableView { get }

	func numberOfRows(in section: Int) -> Int
	func cell(row: Int, section: Int) -> UITableViewCell?
}

extension TableViewRenderer {
	func numberOfRenderedItems() -> Int {
		numberOfRows(in: 0)
	}

	func view(at index: Int) -> UIView? {
		cell(row: index, section: 0)
	}

	func cell(row: Int, section: Int) -> UITableViewCell? {
		guard numberOfRows(in: section) > row else { return nil }

		let dataSource = tableView.dataSource
		let indexPath = IndexPath(row: row, section: section)
		return dataSource?.tableView(tableView, cellForRowAt: indexPath)
	}

	func numberOfRows(in section: Int) -> Int {
		tableView.numberOfSections == 0 ? 0 : tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
	}

	func simulateTapOnItem(at row: Int) {
		let delegate = tableView.delegate
		let indexPath = IndexPath(row: row, section: 0)
		delegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}
}
