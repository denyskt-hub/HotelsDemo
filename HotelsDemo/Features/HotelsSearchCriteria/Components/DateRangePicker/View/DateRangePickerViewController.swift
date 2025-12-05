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
	private let interactor: DateRangePickerBusinessLogic
	private weak var delegate: DateRangePickerDelegate?

	private let rootView = DateRangePickerRootView()

	private let weekdaysDataSource = WeekdaysDataSource()
	private let weekdaysLayoutDelegate = WeekdaysLayoutDelegate()

	private typealias CalendarSection = DateRangePickerModels.CalendarMonthViewModel
	private typealias CalendarItem = DateRangePickerModels.CalendarDateViewModel
	private var calendarDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>!

	public var weekdaysCollectionView: UICollectionView { rootView.weekdaysCollectionView }
	public var collectionView: UICollectionView { rootView.collectionView }
	public var applyButton: UIButton { rootView.applyButton }

	public init(
		interactor: DateRangePickerBusinessLogic,
		delegate: DateRangePickerDelegate?
	) {
		self.interactor = interactor
		self.delegate = delegate
		super.init()
	}

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupWeekdaysCollectionView()
		setupCollectionView()
		setupCalendarDataSource()
		setupApplyButton()

		interactor.doFetchCalendar(request: .init())
	}

	private func setupWeekdaysCollectionView() {
		weekdaysCollectionView.dataSource = weekdaysDataSource
		weekdaysCollectionView.delegate = weekdaysLayoutDelegate
		weekdaysCollectionView.register(WeekdayCell.self)
	}

	private func setupCollectionView() {
		collectionView.delegate = self
	}

	private func setupCalendarDataSource() {
		let cellRegistration = UICollectionView.CellRegistration<DateCell, CalendarItem> { cell, _, cellViewModel in
			cell.configure(cellViewModel)
		}

		calendarDataSource = UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>(
			collectionView: collectionView
		) { collectionView, indexPath, item in
			collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: item
			)
		}

		let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
			elementKind: UICollectionView.elementKindSectionHeader
		) { headerView, _, indexPath in
				let section = self.calendarDataSource.snapshot().sectionIdentifiers[indexPath.section]
				headerView.label.text = section.title
		}

		calendarDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
			guard kind == UICollectionView.elementKindSectionHeader else { return nil }

			return collectionView.dequeueConfiguredReusableSupplementary(
				using: headerRegistration,
				for: indexPath
			)
		}
	}

	private func setupApplyButton() {
		applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
	}

	private func reloadData(_ sections: [CalendarSection]) {
		var snapshot = NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem>()
		snapshot.appendSections(sections)
		for section in sections {
			snapshot.appendItems(section.dates, toSection: section)
		}
		calendarDataSource.apply(snapshot, animatingDifferences: false)
	}

	public func display(viewModel: DateRangePickerModels.FetchCalendar.ViewModel) {
		weekdaysDataSource.weekdays = viewModel.calendar.weekdays
		weekdaysCollectionView.reloadData()

		reloadData(viewModel.calendar.sections)

		applyButton.isEnabled = viewModel.isApplyEnabled
	}

	public func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel) {
		weekdaysDataSource.weekdays = viewModel.calendar.weekdays
		weekdaysCollectionView.reloadData()

		reloadData(viewModel.calendar.sections)

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
		interactor.handleDateRangeSelection(request: DateRangePickerModels.DateRangeSelection.Request())
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

extension DateRangePickerViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	public func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		guard let date = calendarDataSource.itemIdentifier(for: indexPath)?.date else {
			return
		}

		interactor.handleDateSelection(request: .init(date: date))
	}

	public func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.bounds.width, height: 44)
	}

	public func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let numberOfColumns = CGFloat(7)
		let itemWidth = collectionView.bounds.width / numberOfColumns
		return CGSize(width: itemWidth, height: itemWidth)
	}
}
