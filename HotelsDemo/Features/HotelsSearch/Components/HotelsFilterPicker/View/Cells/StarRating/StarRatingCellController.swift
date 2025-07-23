//
//  StarRatingCellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import UIKit

public protocol StarRatingCellControllerDelegate: AnyObject {
	func starRatingSelection(_ starRating: Int)
}

public final class StarRatingCellController: NSObject {
	private let viewModel: HotelsFilterPickerModels.FilterOptionViewModel<Int>
	private var cell: StarRatingCell?

	public var delegate: StarRatingCellControllerDelegate?

	public init(viewModel: HotelsFilterPickerModels.FilterOptionViewModel<Int>) {
		self.viewModel = viewModel
	}
}

// MARK: - UITableViewDataSource

extension StarRatingCellController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: StarRatingCell = tableView.dequeueReusableCell()
		cell.configure(with: viewModel)
		cell.onSelect = { [weak self] starRating in
			self?.delegate?.starRatingSelection(starRating)
		}
		self.cell = cell
		return cell
	}
}
