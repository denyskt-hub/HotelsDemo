//
//  DateRangePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

public protocol DataRangePickerDelegate: AnyObject {
	func didSelectDateRange(startDate: Date, endDate: Date)
}

public protocol DateRangePickerDisplayLogic: AnyObject {
	func display(viewModel: DateRangePickerModels.Load.ViewModel)
	func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel)
	func displaySelectedDateRange(viewModel: DateRangePickerModels.Select.ViewModel)
}

public final class DateRangePickerViewController: NiblessViewController, DateRangePickerDisplayLogic {
	private let rootView = DateRangePickerRootView()
	private var viewModel: DateRangePickerModels.CalendarViewModel?

	public var interactor: DateRangePickerBusinessLogic?
	public weak var delegate: DataRangePickerDelegate?

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupWeekdaysCollectionView()
		setupCollectionView()
		setupApplyButton()

		interactor?.load(request: DateRangePickerModels.Load.Request())
	}

	private func setupWeekdaysCollectionView() {
		rootView.weekdaysCollectionView.dataSource = self
		rootView.weekdaysCollectionView.register(WeekdayCell.self)
	}

	private func setupCollectionView() {
		rootView.collectionView.dataSource = self
		rootView.collectionView.delegate = self
		rootView.collectionView.register(DateCell.self)
		rootView.collectionView.register(
			SectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SectionHeaderView.reuseIdentifier
		)
	}

	private func setupApplyButton() {
		rootView.applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
	}

	public func display(viewModel: DateRangePickerModels.Load.ViewModel) {
		self.viewModel = viewModel.calendar
		rootView.weekdaysCollectionView.reloadData()
		rootView.collectionView.reloadData()
	}

	public func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel) {
		self.viewModel = viewModel.calendar
		rootView.collectionView.reloadData()
	}

	public func displaySelectedDateRange(viewModel: DateRangePickerModels.Select.ViewModel) {
		delegate?.didSelectDateRange(
			startDate: viewModel.startDate,
			endDate: viewModel.endDate
		)
		dismiss(animated: true)
	}

	@objc private func didApply() {
		interactor?.selectDateRange(request: DateRangePickerModels.Select.Request())
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
		cell.delegate = self
		if let cellViewModel = viewModel?.sections[indexPath.section].dates[indexPath.row] {
			cell.configure(cellViewModel)
		}
		return cell
	}

	public func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		guard kind == UICollectionView.elementKindSectionHeader else {
			fatalError("Unsupported kind")
		}

		let sectionViewModel = viewModel?.sections[indexPath.section]

		let header = collectionView.dequeueReusableSupplementaryView(
			ofKind: kind,
			withReuseIdentifier: SectionHeaderView.reuseIdentifier,
			for: indexPath
		) as! SectionHeaderView
		header.label.text = sectionViewModel?.title

		return header
	}
}

extension DateRangePickerViewController: UICollectionViewDelegateFlowLayout {
	public func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 44)
	}
}

extension DateRangePickerViewController: DateCellDelegate {
	func dateCellDidTap(_ cell: DateCell) {
		guard let indexPath = rootView.collectionView.indexPath(for: cell) else {
			return
		}
		guard let date = viewModel?.sections[indexPath.section].dates[indexPath.row].date else {
			return
		}

		interactor?.didSelectDate(request: .init(date: date))
	}
}
