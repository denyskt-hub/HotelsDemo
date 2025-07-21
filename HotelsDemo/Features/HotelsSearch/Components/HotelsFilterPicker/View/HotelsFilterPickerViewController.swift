//
//  HotelsFilterPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import UIKit

public protocol HotelsFilterPickerDelegate: AnyObject {}

public final class HotelsFilterPickerViewController: NiblessViewController, HotelsFilterPickerDisplayLogic {
	private let rootView = HotelsFilterPickerRootView()

	public var interactor: HotelsFilterPickerBusinessLogic?
	public weak var delegate: HotelsFilterPickerDelegate?

	public var tableView: UITableView { rootView.tableView }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTitle()
		setupNavigationBar()
		setupTableView()

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
	}

	public func displayLoad(viewModel: HotelsFilterPickerModels.Load.ViewModel) {

	}

	@objc private func close() {
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UITableViewDataSource

extension HotelsFilterPickerViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		UITableViewCell()
	}
}
