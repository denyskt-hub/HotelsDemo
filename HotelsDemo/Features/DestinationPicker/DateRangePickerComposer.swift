//
//  DateRangePickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import UIKit
import Foundation

public protocol DateRangePickerFactory {
	func makeDateRangePicker(
		delegate: DataRangePickerDelegate?,
		selectedStartDate: Date,
		selectedEndDate: Date,
		calendar: Calendar
	) -> UIViewController
}

public final class DateRangePickerComposer: DateRangePickerFactory {
	public func makeDateRangePicker(
		delegate: DataRangePickerDelegate?,
		selectedStartDate: Date,
		selectedEndDate: Date,
		calendar: Calendar
	) -> UIViewController {
		let viewController = DateRangePickerViewController()
		let interactor = DateRangePickerInteractor(
			selectedStartDate: selectedStartDate,
			selectedEndDate: selectedEndDate,
			generator: DefaultCalendarDataGenerator(
				calendar: calendar,
				currentDate: Date.init
			)
		)
		let presenter = DataRangePickerPresenter(
			dateFormatter: DefaultCalendarDateFormatter(calendar: calendar)
		)

		viewController.interactor = interactor
		viewController.delegate = delegate
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}
}
