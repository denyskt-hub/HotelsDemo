//
//  DateRangePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

public protocol DateRangePickerDisplayLogic: AnyObject {
	func display(viewModel: DateRangePickerModels.Load.ViewModel)
}

public final class DateRangePickerViewController: NiblessViewController, DateRangePickerDisplayLogic {
	private let rootView = DateRangePickerRootView()
	private var viewModel: DateRangePickerModels.Load.ViewModel?

	public var interactor: DateRangePickerBusinessLogic?

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupWeekdaysCollectionView()
		setupCollectionView()

		interactor?.load(request: DateRangePickerModels.Load.Request())
	}

	private func setupWeekdaysCollectionView() {
		rootView.weekdaysCollectionView.dataSource = self
		rootView.weekdaysCollectionView.register(WeekdayCell.self)
	}

	private func setupCollectionView() {
		rootView.collectionView.dataSource = self
		rootView.collectionView.register(DateCell.self)
	}

	public func display(viewModel: DateRangePickerModels.Load.ViewModel) {
		self.viewModel = viewModel
		rootView.weekdaysCollectionView.reloadData()
		rootView.collectionView.reloadData()
	}
}

extension DateRangePickerViewController: UICollectionViewDataSource {
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		if collectionView == rootView.weekdaysCollectionView {
			return 1
		}

		return viewModel?.sections.count ?? 0
	}

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == rootView.weekdaysCollectionView {
			return viewModel?.weekdays.count ?? 0
		}

		return viewModel?.sections[section].dates.count ?? 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == rootView.weekdaysCollectionView {
			let cell: WeekdayCell = collectionView.dequeueReusableCell(for: indexPath)
			cell.label.text = viewModel?.weekdays[indexPath.row]
			return cell
		}

		let cell: DateCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.setTitle(viewModel?.sections[indexPath.section].dates[indexPath.row].date ?? "")
		return cell
	}
}
