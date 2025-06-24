//
//  SearchCriteriaRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

final class SearchCriteriaRouter: SearchCriteriaRoutingLogic {
	weak var viewController: UIViewController?

	func routeToDestinationPicker() {
		let destinationVC = DestinationPickerViewController()
		let worker = DestinationSearchWorker(
			url: URL(string: "https://booking-com15.p.rapidapi.com/api/v1/hotels/searchDestination")!,
			client: URLSessionHTTPClient(),
			dispatcher: MainQueueDispatcher()
		)
		let interactor = DestinationPickerInteractor(worker: worker)
		let presenter = DestinationPickerPresenter()

		destinationVC.interactor = interactor
		destinationVC.delegate = self
		interactor.presenter = presenter
		presenter.viewController = destinationVC

		viewController?.present(destinationVC, animated: true)
	}

	func routeToDateRangePicker(viewModel: DateRangePickerModels.ViewModel) {
		let calendar = Calendar(identifier: .gregorian)

		let monthTitleFormatter = DateFormatter()
		monthTitleFormatter.dateFormat = "LLLL yyyy"
		monthTitleFormatter.calendar = calendar

		let dayFormatter = DateFormatter()
		dayFormatter.dateFormat = "d"
		dayFormatter.calendar = calendar

		let dateRangeVC = DateRangePickerViewController()
		let interactor = DateRangePickerInteractor(
			startDate: viewModel.startDate,
			endDate: viewModel.endDate,
			calendar: calendar
		)
		let presenter = DataRangePickerPresenter(
			monthTitleFormatter: monthTitleFormatter,
			dayFormatter: dayFormatter
		)

		dateRangeVC.interactor = interactor
		dateRangeVC.delegate = self
		interactor.presenter = presenter
		presenter.viewController = dateRangeVC

		viewController?.present(dateRangeVC, animated: true)
	}

	func routeToRoomGuestsPicker(viewModel: RoomGuestsPickerModels.ViewModel) {
		let roomGuestsVC = RoomGuestsPickerViewController()
		let interactor = RoomGuestsPickerInteractor(
			rooms: viewModel.rooms,
			adults: viewModel.adults,
			childrenAge: viewModel.childrenAge
		)
		let presenter = RoomGuestsPickerPresenter()

		roomGuestsVC.interactor = interactor
		roomGuestsVC.delegate = self
		interactor.presenter = presenter
		presenter.viewController = roomGuestsVC

		viewController?.present(roomGuestsVC, animated: true)
	}
}

extension SearchCriteriaRouter: DestinationPickerDelegate {
	func didSelectDestination(_ destination: Destination) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateDestination(
			request: SearchCriteriaModels.UpdateDestination.Request(destination: destination)
		)
	}
}

extension SearchCriteriaRouter: DataRangePickerDelegate {
	func didSelectDateRange(startDate: Date, endDate: Date) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateDates(
			request: SearchCriteriaModels.UpdateDates.Request(checkInDate: startDate, checkOutDate: endDate)
		)
	}
}

extension SearchCriteriaRouter: RoomGuestsPickerDelegate {
	func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateRoomGuests(
			request: SearchCriteriaModels.UpdateRoomGuests.Request(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAges
			)
		)
	}
}
