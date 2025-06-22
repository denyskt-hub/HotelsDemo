//
//  RoomGuestsPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

final class RoomGuestsPickerPresenter: RoomGuestsPickerPresentationLogic {
	weak var viewController: RoomGuestsPickerDisplayLogic?

	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response) {
		viewController?.applyLimits(response.limits)
	}

	func presentRoomGuests(response: RoomGuestsPickerModels.Load.Response) {
		let viewModel = RoomGuestsPickerModels.Load.ViewModel(
			rooms: response.rooms,
			adults: response.adults,
			childrenAge: makeAgeInputViewModels(response.childrenAge)
		)
		viewController?.displayRoomGuests(viewModel: viewModel)
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
			childrenAge: makeAgeInputViewModels(response.childrenAge)
		)
		viewController?.displayChildrenAge(viewModel: viewModel)
	}

	func presentAgePicker(response: RoomGuestsPickerModels.AgeSelection.Response) {
		let viewModel = RoomGuestsPickerModels.AgeSelection.ViewModel(
			index: response.index,
			selectedIndex: response.selectedAge.flatMap({ response.availableAges.firstIndex(of: $0) }),
			availableAges: response.availableAges.map({ ($0, AgeFormatter.string(for: $0)) })
		)
		viewController?.displayAgePicker(viewModel: viewModel)
	}

	func presentChildrenAge(response: RoomGuestsPickerModels.AgeSelected.Response) {
		let viewModel = RoomGuestsPickerModels.AgeSelected.ViewModel(
			childrenAge: makeAgeInputViewModels(response.childrenAge)
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

	private func makeAgeInputViewModels(_ childrenAge: [Int?]) -> [RoomGuestsPickerModels.AgeInputViewModel] {
		childrenAge.enumerated().map(makeAgeInputViewModel)
	}

	private func makeAgeInputViewModel(_ index: Int, age: Int?) -> RoomGuestsPickerModels.AgeInputViewModel {
		RoomGuestsPickerModels.AgeInputViewModel(
			index: index,
			title: ChildTitleFormatter.title(for: index),
			selectedAgeTitle: age.map({ AgeFormatter.string(for: $0) }) ?? "Select age",
		)
	}
}
