//
//  SearchViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class SearchViewController: NiblessViewController {
	private let rootView = SearchRootView()
	private var cellControllers = [HotelCellController]()

	public var interactor: SearchBusinessLogic?

	public var tableView: UITableView { rootView.tableView }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()

		interactor?.search(request: .init())
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(HotelCell.self)
	}

	public func display(_ cellControllers: [HotelCellController]) {
		self.cellControllers = cellControllers
		tableView.reloadData()
	}

	public func displaySearchError(viewModel: SearchModels.ErrorViewModel) {
		displayErrorMessage(viewModel.message)
	}

	private func cellController(at indexPath: IndexPath) -> HotelCellController {
		cellControllers[indexPath.row]
	}
}

extension SearchViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cellControllers.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellController = cellController(at: indexPath)
		return cellController.tableView(tableView, cellForRowAt: indexPath)
	}
}

extension SearchViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cellController = cellController(at: indexPath)
		cellController.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cellController = cellController(at: indexPath)
		cellController.tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
	}
}
