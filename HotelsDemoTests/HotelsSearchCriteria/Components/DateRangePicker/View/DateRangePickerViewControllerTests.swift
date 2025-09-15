//
//  DateRangePickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 7/7/25.
//

import XCTest
import HotelsDemo

final class DateRangePickerViewControllerTests: XCTestCase {
	func test_viewDidLoad_loadInitialData() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.doFetchCalendar(.init())])
	}

	func test_display_rendersCalendar() {
		let calendarViewModel = makeCalendarViewModel()
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.display(viewModel: .init(calendar: calendarViewModel, isApplyEnabled: false))

		assertThat(sut, isRendering: calendarViewModel)
	}

	func test_displaySelectDate_rendersCalendar() {
		let calendarViewModel = makeCalendarViewModel()
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displaySelectDate(viewModel: .init(calendar: calendarViewModel, isApplyEnabled: false))

		assertThat(sut, isRendering: calendarViewModel)
	}

	func test_displaySelectDate_updatesApplyButtonState() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		XCTAssertEqual(sut.applyButton.isEnabled, false)

		sut.displaySelectDate(viewModel: .init(calendar: makeCalendarViewModel(), isApplyEnabled: true))
		XCTAssertEqual(sut.applyButton.isEnabled, true)

		sut.displaySelectDate(viewModel: .init(calendar: makeCalendarViewModel(), isApplyEnabled: false))
		XCTAssertEqual(sut.applyButton.isEnabled, false)
	}

	func test_displaySelectedDateRange_notifiesDelegateWithSelectedDates() {
		let startDate = "07.07.2025".date()
		let endDate = "08.07.2025".date()
		let (sut, _, delegate) = makeSUT()

		sut.displaySelectedDateRange(viewModel: .init(startDate: startDate, endDate: endDate))

		XCTAssertEqual(delegate.messages, [.didSelectDateRange(startDate, endDate)])
	}

	func test_dateCellDidTap_selectsDate() {
		let date = "07.07.2025".date()
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.display(viewModel: .init(calendar: makeCalendarViewModel(date), isApplyEnabled: false))

		sut.simulateTapOnDate(item: 0, section: 0)

		XCTAssertEqual(interactor.messages.last, .handleDateSelection(.init(date: date)))
	}

	func test_applyButtonTap_selectsDateRange() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateApplyButtonTap()

		XCTAssertEqual(interactor.messages.last, .handleDateRangeSelection(.init()))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DateRangePickerViewController,
		interactor: DateRangePickerBusinessLogicSpy,
		delegate: DateRangePickerDelegateSpy
	) {
		let interactor = DateRangePickerBusinessLogicSpy()
		let delegate = DateRangePickerDelegateSpy()
		let sut = DateRangePickerViewController()
		sut.interactor = interactor
		sut.delegate = delegate
		return (sut, interactor, delegate)
	}

	private func makeCalendarViewModel(_ date: Date = .now) -> DateRangePickerModels.CalendarViewModel {
		let dateViewModel = DateRangePickerModels.CalendarDateViewModel(
			date: date,
			title: "date title"
		)
		let monthViewModel = DateRangePickerModels.CalendarMonthViewModel(
			title: "month title",
			dates: [dateViewModel]
		)
		return DateRangePickerModels.CalendarViewModel(
			weekdays: anyWeekdays(),
			sections: [monthViewModel]
		)
	}

	private func assertThat(
		_ sut: DateRangePickerViewController,
		isRendering viewModel: DateRangePickerModels.CalendarViewModel,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		sut.view.enforceLayoutCycle()

		guard sut.numberOfRenderedWeekdays() == viewModel.weekdays.count else {
			return XCTFail("Expect \(viewModel.weekdays.count) images, got \(sut.numberOfRenderedWeekdays()) instead", file: file, line: line)
		}

		for (item, weekday) in viewModel.weekdays.enumerated() {
			assertThat(sut, hasWeekdayViewConfiguredFor: weekday, item: item, file: file, line: line)
		}

		guard sut.numberOfRenderedMonths() == viewModel.sections.count else {
			return XCTFail("Expect \(viewModel.sections.count) images, got \(sut.numberOfRenderedMonths()) instead", file: file, line: line)
		}

		for (section, monthViewModel) in viewModel.sections.enumerated() {
			assertThat(sut, hasMonthViewConfiguredFor: monthViewModel, section: section, file: file, line: line)
		}
	}

	private func assertThat(
		_ sut: DateRangePickerViewController,
		hasMonthViewConfiguredFor monthViewModel: DateRangePickerModels.CalendarMonthViewModel,
		section: Int,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let view = sut.monthView(section: section)
		guard let headerView = view as? SectionHeaderView else {
			return XCTFail("Expected \(SectionHeaderView.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(headerView.label.text, monthViewModel.title, "Expected title to be \(monthViewModel.title) for month view at section (\(section))", file: file, line: line)

		guard sut.numberOfRenderedDates(in: section) == monthViewModel.dates.count else {
			return XCTFail("Expected \(monthViewModel.dates.count) images, got \(sut.numberOfRenderedDates(in: section)) instead", file: file, line: line)
		}

		for (item, dateViewModel) in monthViewModel.dates.enumerated() {
			assertThat(sut, hasDateViewConfiguredFor: dateViewModel, item: item, section: section, file: file, line: line)
		}
	}

	private func assertThat(
		_ sut: DateRangePickerViewController,
		hasWeekdayViewConfiguredFor weekday: String,
		item: Int,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let view = sut.weekdayView(item: item)
		guard let cell = view as? WeekdayCell else {
			return XCTFail("Expected \(WeekdayCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.label.text, weekday, "Expected title to be \(weekday) for weekday view at item (\(item))", file: file, line: line)
	}

	private func assertThat(
		_ sut: DateRangePickerViewController,
		hasDateViewConfiguredFor dateViewModel: DateRangePickerModels.CalendarDateViewModel,
		item: Int,
		section: Int,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let view = sut.dateView(item: item, section: section)
		guard let cell = view as? DateCell else {
			return XCTFail("Expected \(DateCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.button.title(for: .normal), dateViewModel.title, "Expected title to be \(String(describing: dateViewModel.title)) for date view at item (\(item)) section (\(section))", file: file, line: line)

		XCTAssertEqual(cell.button.isEnabled, dateViewModel.isEnabled, "Expected `isEnabled` to be \(dateViewModel.isEnabled) for date view at item (\(item)) section (\(section))", file: file, line: line)

		XCTAssertEqual(cell.isToday, dateViewModel.isToday, "Expected `isToday` to be \(dateViewModel.isToday) for date view at item (\(item)) section (\(section))", file: file, line: line)

		XCTAssertEqual(cell.isSelectedDate, dateViewModel.isSelected, "Expected `isSelected` to be \(dateViewModel.isSelected) for date view at item (\(item)) section (\(section))", file: file, line: line)

		XCTAssertEqual(cell.isInRange, dateViewModel.isInRange, "Expected `isInRange` to be \(dateViewModel.isInRange) for date view at item (\(item)) section (\(section))", file: file, line: line)
	}
}

extension DateRangePickerViewController {
	func simulateTapOnDate(item: Int, section: Int) {
		let indexPath = IndexPath(item: item, section: section)
		guard let cell = dateCell(at: indexPath) as? DateCell else { return }

		cell.delegate?.dateCellDidTap(cell, at: indexPath)
	}

	func simulateApplyButtonTap() {
		applyButton.simulateTap()
	}

	func numberOfRenderedWeekdays() -> Int {
		numberOfWeekdayItems()
	}

	func weekdayView(item: Int) -> UICollectionViewCell? {
		weekdayCell(at: IndexPath(item: item, section: 0))
	}

	func numberOfRenderedMonths() -> Int {
		collectionView.numberOfSections
	}

	func monthView(section: Int) -> UICollectionReusableView? {
		let indexPath = IndexPath(item: 0, section: section)
		let dataSource = collectionView.dataSource
		return dataSource?.collectionView?(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
	}

	func numberOfRenderedDates(in section: Int) -> Int {
		numberOfDateItems(in: section)
	}

	func dateView(item: Int, section: Int) -> UICollectionViewCell? {
		dateCell(at: IndexPath(item: item, section: section))
	}

	private func weekdayCell(at indexPath: IndexPath) -> UICollectionViewCell? {
		guard numberOfWeekdayItems() > indexPath.item else { return nil }

		let dataSource = weekdaysCollectionView.dataSource
		return dataSource?.collectionView(weekdaysCollectionView, cellForItemAt: indexPath)
	}

	private func numberOfWeekdayItems() -> Int {
		weekdaysCollectionView.numberOfItems(inSection: 0)
	}

	private func dateCell(at indexPath: IndexPath) -> UICollectionViewCell? {
		guard numberOfDateItems(in: indexPath.section) > indexPath.item else { return nil }

		let dataSource = collectionView.dataSource
		return dataSource?.collectionView(collectionView, cellForItemAt: indexPath)
	}

	private func numberOfDateItems(in section: Int) -> Int {
		collectionView.numberOfSections == 0 ? 0 : collectionView.numberOfSections > section ? collectionView.numberOfItems(inSection: section) : 0
	}
}

final class DateRangePickerBusinessLogicSpy: DateRangePickerBusinessLogic {
	enum Message: Equatable {
		case doFetchCalendar(DateRangePickerModels.FetchCalendar.Request)
		case handleDateSelection(DateRangePickerModels.DateSelection.Request)
		case handleDateRangeSelection(DateRangePickerModels.DateRangeSelection.Request)
	}

	private(set) var messages = [Message]()

	func doFetchCalendar(request: DateRangePickerModels.FetchCalendar.Request) {
		messages.append(.doFetchCalendar(request))
	}

	func handleDateSelection(request: DateRangePickerModels.DateSelection.Request) {
		messages.append(.handleDateSelection(request))
	}

	func handleDateRangeSelection(request: DateRangePickerModels.DateRangeSelection.Request) {
		messages.append(.handleDateRangeSelection(request))
	}
}

final class DateRangePickerDelegateSpy: DateRangePickerDelegate {
	enum Message: Equatable {
		case didSelectDateRange(Date, Date)
	}

	private(set) var messages = [Message]()

	func didSelectDateRange(startDate: Date, endDate: Date) {
		messages.append(.didSelectDateRange(startDate, endDate))
	}
}
