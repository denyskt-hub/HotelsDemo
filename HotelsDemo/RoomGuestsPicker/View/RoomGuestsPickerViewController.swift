//
//  RoomGuestsPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public protocol RoomGuestsPickerDelegate: AnyObject {

}

public protocol RoomGuestsPickerDisplayLogic: AnyObject {
	func applyLimits(_ limits: RoomGuestsLimits)
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel)
	func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel)
	func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel)
	func displayChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel)
}

public final class RoomGuestsPickerViewController: NiblessViewController, RoomGuestsPickerDisplayLogic {
	private let rootView = RoomGuestsPickerRootView()

	var interactor: RoomGuestsPickerBusinessLogic?
	weak var delegate: RoomGuestsPickerDelegate?

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupRoomsStepper()
		setupAdultsStepper()
		setupChildrenStepper()

		interactor?.loadRoomGuestsLimits(request: RoomGuestsPickerModels.LoadLimits.Request())
	}

	private func setupRoomsStepper() {
		rootView.roomsStepper.decrementButton.addTarget(self, action: #selector(didDecrementRooms), for: .touchUpInside)
		rootView.roomsStepper.incrementButton.addTarget(self, action: #selector(didIncrementRooms), for: .touchUpInside)
	}

	private func setupAdultsStepper() {
		rootView.adultsStepper.decrementButton.addTarget(self, action: #selector(didDecrementAdults), for: .touchUpInside)
		rootView.adultsStepper.incrementButton.addTarget(self, action: #selector(didIncrementAdults), for: .touchUpInside)
	}

	private func setupChildrenStepper() {
		rootView.childrenStepper.decrementButton.addTarget(self, action: #selector(didDecrementChildren), for: .touchUpInside)
		rootView.childrenStepper.incrementButton.addTarget(self, action: #selector(didIncrementChildren), for: .touchUpInside)
	}

	public func applyLimits(_ limits: RoomGuestsLimits) {
		rootView.roomsStepper.setRange(minimumValue: 1, maximumValue: limits.maxRooms)
		rootView.adultsStepper.setRange(minimumValue: 1, maximumValue: limits.maxAdults)
		rootView.childrenStepper.setRange(minimumValue: 0, maximumValue: limits.maxChildren)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		rootView.roomsStepper.setValue(viewModel.rooms)
		rootView.adultsStepper.setValue(viewModel.adults)
		rootView.childrenStepper.setValue(viewModel.children)
	}

	public func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel) {
		rootView.roomsStepper.setValue(viewModel.rooms)
	}

	public func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel) {
		rootView.adultsStepper.setValue(viewModel.adults)
	}

	public func displayChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel) {
		rootView.childrenStepper.setValue(viewModel.children)
	}

	@objc private func didDecrementRooms() {
		interactor?.didDecrementRooms()
	}

	@objc private func didIncrementRooms() {
		interactor?.didIncrementRooms()
	}

	@objc private func didDecrementAdults() {
		interactor?.didDecrementAdults()
	}

	@objc private func didIncrementAdults() {
		interactor?.didIncrementAdults()
	}

	@objc private func didDecrementChildren() {
		interactor?.didDecrementChildrenAge()
	}

	@objc private func didIncrementChildren() {
		interactor?.didIncrementChildrenAge()
	}
}
