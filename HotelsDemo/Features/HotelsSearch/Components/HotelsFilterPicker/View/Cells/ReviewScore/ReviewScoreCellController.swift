//
//  ReviewScoreCellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/7/25.
//

import UIKit

public protocol ReviewScoreCellControllerDelegate: AnyObject {}

public final class ReviewScoreCellController: NSObject {
	private let viewModel: HotelsFilterPickerModels.FilterOptionViewModel<ReviewScore>
	private var cell: ReviewScoreCell?

	public var delegate: ReviewScoreCellControllerDelegate?

	public init(viewModel: HotelsFilterPickerModels.FilterOptionViewModel<ReviewScore>) {
		self.viewModel = viewModel
	}
}

// MARK: - UITableViewDataSource

extension ReviewScoreCellController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ReviewScoreCell = tableView.dequeueReusableCell()
		cell.configure(with: viewModel)
		self.cell = cell
		return cell
	}
}
