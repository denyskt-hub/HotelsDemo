//
//  SearchViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class SearchViewController: NiblessViewController, SearchDisplayLogic {
	private let rootView = SearchRootView()
	private var viewModel = SearchModels.Search.ViewModel(hotels: [])

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
	}

	public func displaySearch(viewModel: SearchModels.Search.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}

	public func displaySearchError(viewModel: SearchModels.ErrorViewModel) {
		displayErrorMessage(viewModel.message)
	}
}

extension SearchViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.hotels.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		let hotel = viewModel.hotels[indexPath.row]
		cell.textLabel?.text = hotel.name
		return cell
	}
}
