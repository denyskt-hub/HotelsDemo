//
//  ReviewScoreViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public protocol ReviewScoreDelegate: AnyObject {
	func didSelectReviewScore(_ reviewScore: ReviewScore?)
}

public final class ReviewScoreViewController: NiblessViewController, ReviewScoreDisplayLogic {
	private let delegate: ReviewScoreDelegate
	private let rootView = ReviewScoreRootView()
	private var options = [ReviewScoreModels.OptionViewModel]()

	public var interactor: ReviewScoreBusinessLogic?

	public var tableView: UITableView { rootView.tableView }

	public init(delegate: ReviewScoreDelegate) {
		self.delegate = delegate
		super.init()
	}

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()

		interactor?.doFetchReviewScore(request: .init())
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self

		tableView.register(ReviewScoreCell.self)
	}

	public func display(viewModel: ReviewScoreModels.FetchReviewScore.ViewModel) {
		display(viewModel.options)
	}

	public func displayReset(viewModel: ReviewScoreModels.ReviewScoreReset.ViewModel) {
		display(viewModel.options)
	}

	public func displaySelect(viewModel: ReviewScoreModels.ReviewScoreSelection.ViewModel) {
		delegate.didSelectReviewScore(viewModel.reviewScore)
		display(viewModel.options)
	}

	private func display(_ options: [ReviewScoreModels.OptionViewModel]) {
		self.options = options
		tableView.reloadData()
	}
}

// MARK: - ResetableFilterViewController

extension ReviewScoreViewController: ResetableFilterViewController {
	public func reset() {
		interactor?.handleReviewScoreReset(request: .init())
	}
}

// MARK: - UITableViewDataSource

extension ReviewScoreViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		options.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ReviewScoreCell = tableView.dequeueReusableCell()
		cell.configure(with: options[indexPath.row])
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ReviewScoreViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let option = options[indexPath.row]
		interactor?.handleReviewScoreSelection(request: .init(reviewScore: option.value))
	}
}
