//
//  HotelsFilterPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import UIKit

public protocol HotelsFilterPickerDelegate: AnyObject {
	func didSelectFilter(_ filter: HotelsFilter)
}

public final class HotelsFilterPickerViewController: NiblessViewController {
	private var sections = [FilterSection]()
	private let rootView = HotelsFilterPickerRootView()

	public var interactor: HotelsFilterPickerBusinessLogic?
	public weak var delegate: HotelsFilterPickerDelegate?

	public var tableView: UITableView { rootView.tableView }
	public var applyButton: UIButton { rootView.applyButton }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTitle()
		setupNavigationBar()
		setupTableView()
		setupApplyButton()

		interactor?.load(request: .init())
	}

	private func setupTitle() {
		title = "Filter"
	}

	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .close,
			target: self,
			action: #selector(close)
		)
		navigationController?.navigationBar.prefersLargeTitles = false
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self

		tableView.register(PriceRangeCell.self)
	}

	private func setupApplyButton() {
		applyButton.addTarget(self, action: #selector(applyTapHandler), for: .touchUpInside)
	}

	public func display(_ sections: [FilterSection]) {
		self.sections = sections
		tableView.reloadData()
	}

	private func cellController(at indexPath: IndexPath) -> CellController {
		sections[indexPath.section].cellControllers[indexPath.row]
	}

	public func displaySelectedFilter(viewModel: HotelsFilterPickerModels.Select.ViewModel) {
		delegate?.didSelectFilter(viewModel.filter)
		dismiss(animated: true)
	}

	@objc private func applyTapHandler() {
		interactor?.selectFilter(request: HotelsFilterPickerModels.Select.Request())
	}

	@objc private func close() {
		dismiss(animated: true)
	}
}

// MARK: - UITableViewDataSource

extension HotelsFilterPickerViewController: UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sections[section].cellControllers.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let ds = cellController(at: indexPath).dataSource
		return ds.tableView(tableView, cellForRowAt: indexPath)
	}
}

// MARK: - UITableViewDelegate

extension HotelsFilterPickerViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = FilterHeaderView()
		view.titleLabel.text = sections[section].title
		return view
	}
}
