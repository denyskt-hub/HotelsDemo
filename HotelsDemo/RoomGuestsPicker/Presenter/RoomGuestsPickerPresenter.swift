//
//  RoomGuestsPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

protocol RoomGuestsPickerPresentationLogic {
	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response)

	func presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response)
	func presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response)
	func presentUpdateChildrenAge(response: RoomGuestsPickerModels.UpdateChildrenAge.Response)

	func presentAgePicker(response: RoomGuestsPickerModels.AgeSelection.Response)
	func presentChildrenAge(response: RoomGuestsPickerModels.AgeSelected.Response)

	func presentSelectedRoomGuests(response: RoomGuestsPickerModels.Select.Response)
}

final class RoomGuestsPickerPresenter: RoomGuestsPickerPresentationLogic {
	weak var viewController: RoomGuestsPickerDisplayLogic?

	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response) {
		viewController?.applyLimits(response.limits)
	}

	func presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response) {
		let viewModel = RoomGuestsPickerModels.UpdateRooms.ViewModel(rooms: response.rooms)
		viewController?.displayRooms(viewModel: viewModel)
	}

	func presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response) {
		let viewModel = RoomGuestsPickerModels.UpdateAdults.ViewModel(adults: response.adults)
		viewController?.displayAdults(viewModel: viewModel)
	}

	func presentUpdateChildrenAge(response: RoomGuestsPickerModels.UpdateChildrenAge.Response) {
		let viewModel = RoomGuestsPickerModels.UpdateChildrenAge.ViewModel(
			childrenAge: response.childrenAge.enumerated().map { (index, age) in
				RoomGuestsPickerModels.AgeInputViewModel(
					index: index,
					title: "Child \(index + 1)",
					selectedAgeTitle: age.map({ "\($0)" }) ?? "Select age",
				)
			}
		)
		viewController?.displayChildrenAge(viewModel: viewModel)
	}

	func presentAgePicker(response: RoomGuestsPickerModels.AgeSelection.Response) {
		let viewModel = RoomGuestsPickerModels.AgeSelection.ViewModel(
			index: response.index,
			selectedIndex: response.selectedAge.flatMap({ response.availableAges.firstIndex(of: $0) }),
			availableAges: response.availableAges.map({ ($0, "\($0)") })
		)
		viewController?.displayAgePicker(viewModel: viewModel)
	}

	func presentChildrenAge(response: RoomGuestsPickerModels.AgeSelected.Response) {
		let viewModel = RoomGuestsPickerModels.AgeSelected.ViewModel(
			childrenAge: response.childrenAge.enumerated().map { (index, age) in
				RoomGuestsPickerModels.AgeInputViewModel(
					index: index,
					title: "Child \(index + 1)",
					selectedAgeTitle: age.map({ "\($0)" }) ?? "Select age",
				)
			}
		)
		viewController?.displayChildrenAge(viewModel: viewModel)
	}

	func presentSelectedRoomGuests(response: RoomGuestsPickerModels.Select.Response) {
		let viewModel = RoomGuestsPickerModels.Select.ViewModel(
			rooms: response.rooms,
			adults: response.adults,
			childrenAge: response.childrenAge
		)
		viewController?.displaySelectedRoomGuests(viewModel: viewModel)
	}
}
