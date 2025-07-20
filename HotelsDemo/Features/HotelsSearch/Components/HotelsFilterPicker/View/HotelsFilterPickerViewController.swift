//
//  HotelsFilterPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import UIKit

public protocol HotelsFilterPickerDelegate: AnyObject {

}

public final class HotelsFilterPickerViewController: NiblessViewController {
	private let rootView = HotelsFilterPickerRootView()

	public var interactor: HotelsFilterPickerBusinessLogic?
	public weak var delegate: HotelsFilterPickerDelegate?

	public var tableView: UITableView { rootView.tableView }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
	}

	private func setupTableView() {
		tableView.dataSource = self
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
