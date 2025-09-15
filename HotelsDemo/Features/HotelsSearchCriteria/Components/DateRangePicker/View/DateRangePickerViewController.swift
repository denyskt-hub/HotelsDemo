//
//  DateRangePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

public protocol DateRangePickerDelegate: AnyObject {
	func didSelectDateRange(startDate: Date, endDate: Date)
}

public final class DateRangePickerViewController: NiblessViewController, DateRangePickerDisplayLogic {
	private let rootView = DateRangePickerRootView()

	private let weekdaysDataSource = WeekdaysDataSource()
	private let weekdaysLayoutDelegate = WeekdaysLayoutDelegate()

	private let calendarDataSource = CalendarDataSource()
	private let calendarLayoutDelegate = CalendarLayoutDelegate()

	public var interactor: DateRangePickerBusinessLogic?
	public weak var delegate: DateRangePickerDelegate?

	public var weekdaysCollectionView: UICollectionView { rootView.weekdaysCollectionView }
	public var collectionView: UICollectionView { rootView.collectionView }
	public var applyButton: UIButton { rootView.applyButton }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupWeekdaysCollectionView()
		setupCollectionView()
		setupApplyButton()

		interactor?.doFetchCalendar(request: .init())
	}

	private func setupWeekdaysCollectionView() {
		weekdaysCollectionView.dataSource = weekdaysDataSource
		weekdaysCollectionView.delegate = weekdaysLayoutDelegate
		weekdaysCollectionView.register(WeekdayCell.self)
	}

	private func setupCollectionView() {
		calendarDataSource.cellDelegate = self
		collectionView.dataSource = calendarDataSource
		collectionView.delegate = calendarLayoutDelegate
		collectionView.register(DateCell.self)
		collectionView.register(SectionHeaderView.self, kind: UICollectionView.elementKindSectionHeader)
	}

	private func setupApplyButton() {
		applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
	}

	public func display(viewModel: DateRangePickerModels.FetchCalendar.ViewModel) {
		weekdaysDataSource.weekdays = viewModel.calendar.weekdays
		weekdaysCollectionView.reloadData()

		calendarDataSource.sections = viewModel.calendar.sections
		collectionView.reloadData()

		applyButton.isEnabled = viewModel.isApplyEnabled
	}

	public func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel) {
		weekdaysDataSource.weekdays = viewModel.calendar.weekdays
		weekdaysCollectionView.reloadData()

		calendarDataSource.sections = viewModel.calendar.sections
		collectionView.reloadData()

		applyButton.isEnabled = viewModel.isApplyEnabled
	}

	public func displaySelectedDateRange(viewModel: DateRangePickerModels.DateRangeSelection.ViewModel) {
		delegate?.didSelectDateRange(
			startDate: viewModel.startDate,
			endDate: viewModel.endDate
		)
		dismiss(animated: true)
	}

	@objc private func didApply() {
		interactor?.handleDateRangeSelection(request: DateRangePickerModels.DateRangeSelection.Request())
	}
}

final class WeekdaysDataSource: NSObject, UICollectionViewDataSource {
	var weekdays = [String]()

	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		weekdays.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell: WeekdayCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.label.text = weekdays[indexPath.item]
		return cell
	}
}

final class WeekdaysLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let numberOfColumns = CGFloat(7)
		let itemWidth = collectionView.bounds.width / numberOfColumns
		return CGSize(width: itemWidth, height: 34)
	}
}

final class CalendarDataSource: NSObject, UICollectionViewDataSource {
	var sections = [DateRangePickerModels.CalendarMonthViewModel]()
	weak var cellDelegate: DateCellDelegate?

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		sections.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		sections[section].dates.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell: DateCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.delegate = cellDelegate
		cell.indexPath = indexPath

		let cellViewModel = sections[indexPath.section].dates[indexPath.row]
		cell.configure(cellViewModel)
		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		guard kind == UICollectionView.elementKindSectionHeader else {
			fatalError("Unsupported kind")
		}

		let sectionHeader: SectionHeaderView = collectionView.dequeueReusableSupplementaryView(
			ofKind: kind,
			for: indexPath
		)

		let sectionViewModel = sections[indexPath.section]
		sectionHeader.label.text = sectionViewModel.title

		return sectionHeader
	}
}

final class CalendarLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.bounds.width, height: 44)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let numberOfColumns = CGFloat(7)
		let itemWidth = collectionView.bounds.width / numberOfColumns
		return CGSize(width: itemWidth, height: itemWidth)
	}
}

extension DateRangePickerViewController: DateCellDelegate {
	public func dateCellDidTap(_ cell: DateCell, at indexPath: IndexPath) {
		guard let date = calendarDataSource.sections[indexPath.section].dates[indexPath.row].date else {
			return
		}

		interactor?.handleDateSelection(request: .init(date: date))
	}
}
