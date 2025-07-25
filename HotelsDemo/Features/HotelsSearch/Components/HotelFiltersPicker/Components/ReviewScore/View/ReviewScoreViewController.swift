//
//  ReviewScoreViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public final class ReviewScoreViewController: NiblessViewController, ReviewScoreDisplayLogic {
	private let rootView = ReviewScoreRootView()
	private var options = [ReviewScoreModels.OptionViewModel]()

	public var interactor: ReviewScoreBusinessLogic?

	public var tableView: UITableView { rootView.tableView }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()

		interactor?.load(request: .init())
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self

		tableView.register(ReviewScoreCell.self)
	}

	public func display(viewModel: ReviewScoreModels.Load.ViewModel) {
		display(viewModel.options)
	}

	public func displayReset(viewModel: ReviewScoreModels.Reset.ViewModel) {
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
		interactor?.reset(request: .init())
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
	}
}
