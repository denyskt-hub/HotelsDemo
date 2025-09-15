//
//  HotelsSearchViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class HotelsSearchViewController: NiblessViewController {
	private let rootView = HotelsSearchRootView()
	private var cellControllers = [HotelCellController]()
	private var onViewIsAppearing: ((HotelsSearchViewController) -> Void)?

	public var interactor: HotelsSearchBusinessLogic?
	public var router: HotelsSearchRoutingLogic?

	public let loadingView = UIActivityIndicatorView(style: .large)
	public var tableView: UITableView { rootView.tableView }

	private var actionBar: HotelsActionBar { rootView.actionBar }
	public var filterButton: UIButton { actionBar.filterButton }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		setupFilterButton()

		onViewIsAppearing = { viewController in
			viewController.onViewIsAppearing = nil
			viewController.interactor?.doSearch(request: .init())
		}
	}

	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent {
			interactor?.doCancelSearch()
		}
	}

	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		onViewIsAppearing?(self)
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableView.contentInset.bottom = tableView.frame.origin.y + tableView.frame.height - actionBar.frame.origin.y
	}

	private func setupTableView() {
		tableView.prefetchDataSource = self
		tableView.dataSource = self
		tableView.delegate = self

		tableView.register(HotelCell.self)
	}

	private func setupFilterButton() {
		filterButton.addTarget(self, action: #selector(filterTapHandler), for: .touchUpInside)
	}

	public func display(_ cellControllers: [HotelCellController]) {
		self.cellControllers = cellControllers
		tableView.reloadData()
	}

	public func display(_ hasSelectedFilters: Bool) {
		filterButton.setBadgeVisible(hasSelectedFilters)
	}

	public func displayLoading(viewModel: HotelsSearchModels.LoadingViewModel) {
		guard viewModel.isLoading else {
			return loadingView.hide()
		}

		loadingView.show(in: view)
	}

	public func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel) {
		displayErrorMessage(viewModel.message)
	}

	public func displayFilters(viewModel: HotelsSearchModels.FetchFilters.ViewModel) {
		router?.routeToHotelFiltersPicker(viewModel: viewModel)
	}

	private func cellController(at indexPath: IndexPath) -> HotelCellController? {
		guard cellControllers.indices.contains(indexPath.row) else {
			return nil
		}
		return cellControllers[indexPath.row]
	}

	@objc private func filterTapHandler() {
		interactor?.doFetchFilters(request: .init())
	}
}

// MARK: - UITableViewDataSource

extension HotelsSearchViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cellControllers.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cellController = cellController(at: indexPath) else {
			preconditionFailure("cellController not found")
		}
		return cellController.tableView(tableView, cellForRowAt: indexPath)
	}
}

// MARK: - UITableViewDataSourcePrefetching

extension HotelsSearchViewController: UITableViewDataSourcePrefetching {
	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
			let cellController = cellController(at: indexPath)
			cellController?.tableView(tableView, prefetchRowsAt: [indexPath])
		}
	}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
			let cellController = cellController(at: indexPath)
			cellController?.tableView(tableView, cancelPrefetchingForRowsAt: [indexPath])
		}
	}
}

// MARK: - UITableViewDelegate

extension HotelsSearchViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cellController = cellController(at: indexPath)
		cellController?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cellController = cellController(at: indexPath)
		cellController?.tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
	}
}

// MARK: - HotelFiltersPickerDelegate

extension HotelsSearchViewController: HotelFiltersPickerDelegate {
	public func didSelectFilters(_ filters: HotelFilters) {
		interactor?.handleFilterSelection(
			request: .init(filters: filters)
		)
	}
}
