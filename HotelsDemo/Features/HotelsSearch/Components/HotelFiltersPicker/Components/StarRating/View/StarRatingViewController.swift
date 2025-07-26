//
//  StarRatingViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import UIKit

public protocol StarRatingDelegate: AnyObject {
	func didSelectStarRatings(_ starRatings: Set<StarRating>)
}

public final class StarRatingViewController: NiblessViewController, StarRatingDisplayLogic {
	private let rootView = StarRatingRootView()
	private var options = [StarRatingModels.OptionViewModel]()

	public var interactor: StarRatingBusinessLogic?
	public var delegate: StarRatingDelegate?

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

		tableView.register(StarRatingCell.self)
	}

	public func display(viewModel: StarRatingModels.Load.ViewModel) {
		display(viewModel.options)
	}

	public func displayReset(viewModel: StarRatingModels.Reset.ViewModel) {
		display(viewModel.options)
	}

	public func displaySelect(viewModel: StarRatingModels.Select.ViewModel) {
		delegate?.didSelectStarRatings(viewModel.starRatings)
		display(viewModel.options)
	}

	private func display(_ options: [StarRatingModels.OptionViewModel]) {
		self.options = options
		tableView.reloadData()
	}
}

// MARK: - ResetableFilterViewController

extension StarRatingViewController: ResetableFilterViewController {
	public func reset() {
		interactor?.reset(request: .init())
	}
}

// MARK: - UITableViewDataSource

extension StarRatingViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		options.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: StarRatingCell = tableView.dequeueReusableCell()
		cell.configure(with: options[indexPath.row])
		return cell
	}
}

// MARK: - UITableViewDelegate

extension StarRatingViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let option = options[indexPath.row]
		interactor?.select(request: .init(starRating: option.value))
	}
}
