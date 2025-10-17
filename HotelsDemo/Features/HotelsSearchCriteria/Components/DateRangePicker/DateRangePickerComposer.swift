//
//  DateRangePickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import UIKit

public protocol DateRangePickerFactory {
	func makeDateRangePicker(
		delegate: DateRangePickerDelegate?,
		selectedStartDate: Date,
		selectedEndDate: Date,
		calendar: Calendar
	) -> UIViewController
}

public final class DateRangePickerComposer: DateRangePickerFactory {
	public func makeDateRangePicker(
		delegate: DateRangePickerDelegate?,
		selectedStartDate: Date,
		selectedEndDate: Date,
		calendar: Calendar
	) -> UIViewController {
		let presenter = DataRangePickerPresenter(
			dateFormatter: DefaultCalendarDateFormatter(calendar: calendar)
		)
		let interactor = DateRangePickerInteractor(
			selectedStartDate: selectedStartDate,
			selectedEndDate: selectedEndDate,
			generator: DefaultCalendarDataGenerator(
				calendar: calendar,
				currentDate: Date.init
			),
			presenter: presenter
		)
		let viewController = DateRangePickerViewController(
			interactor: interactor,
			delegate: delegate
		)

		presenter.viewController = viewController

		return viewController
	}
}
