//
//  DateRangePickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public protocol DateRangePickerPresentationLogic {
	func display(response: DateRangePickerModels.Load.Response)
}

public final class DataRangePickerPresenter: DateRangePickerPresentationLogic {
	private let monthTitleFormatter: DateFormatter
	private let dayFormatter: DateFormatter

	public weak var viewController: DateRangePickerDisplayLogic?

	public init(
		monthTitleFormatter: DateFormatter,
		dayFormatter: DateFormatter
	) {
		self.monthTitleFormatter = monthTitleFormatter
		self.dayFormatter = dayFormatter
	}

	public func display(response: DateRangePickerModels.Load.Response) {
		let viewModel = DateRangePickerModels.Load.ViewModel(
			weekdays: response.weekdays,
			sections: response.sections.map {
				DateRangePickerModels.CalendarMonthViewModel(
					title: monthTitleFormatter.string(from: $0.month),
					dates: $0.dates.map {
						DateRangePickerModels.CalendarDateViewModel(
							date: $0.date.map(dayFormatter.string(from:)),
						)
					}
				)
			}
		)
		viewController?.display(viewModel: viewModel)
	}
}
