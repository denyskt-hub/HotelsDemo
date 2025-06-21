//
//  RoomGuestsPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import UIKit

public protocol RoomGuestsPickerDelegate: AnyObject {
	func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int])
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
		setupApplyButton()

		interactor?.loadLimits(request: RoomGuestsPickerModels.LoadLimits.Request())
		interactor?.load(request: RoomGuestsPickerModels.Load.Request())
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

	private func setupApplyButton() {
		rootView.applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
	}

	public func applyLimits(_ limits: RoomGuestsLimits) {
		rootView.roomsStepper.setRange(minimumValue: 1, maximumValue: limits.maxRooms)
		rootView.adultsStepper.setRange(minimumValue: 1, maximumValue: limits.maxAdults)
		rootView.childrenStepper.setRange(minimumValue: 0, maximumValue: limits.maxChildren)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.Load.ViewModel) {
		rootView.roomsStepper.setValue(viewModel.rooms)
		rootView.adultsStepper.setValue(viewModel.adults)
		displayChildrenAge(viewModel.childrenAge)
	}

	public func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel) {
		rootView.roomsStepper.setValue(viewModel.rooms)
	}

	public func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel) {
		rootView.adultsStepper.setValue(viewModel.adults)
	}

	public func displayChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel) {
		displayChildrenAge(viewModel.childrenAge)
	}

	public func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel) {
		displayChildrenAge(viewModel.childrenAge)
	}

	private func displayChildrenAge(_ childrenAge: [RoomGuestsPickerModels.AgeInputViewModel]) {
		rootView.childrenStepper.setValue(childrenAge.count)

		rootView.childrenStack.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		for ageViewModel in childrenAge {
			let inputView = AgeInputView(viewModel: ageViewModel)
			inputView.delegate = self
			rootView.childrenStack.addArrangedSubview(inputView)
		}
	}

	public func displayAgePicker(viewModel: RoomGuestsPickerModels.AgeSelection.ViewModel) {
		let vc = AgePickerViewController(
			options: viewModel.availableAges.map { $0.title },
			selectedIndex: viewModel.selectedIndex
		) { [weak self] selectedIndex in
			let index = viewModel.index
			let age = viewModel.availableAges[selectedIndex].value
			self?.interactor?.didSelectAge(request: RoomGuestsPickerModels.AgeSelected.Request(index: index, age: age))
		}

		let nav = UINavigationController(rootViewController: vc)
		present(nav, animated: true)
	}

	public func displaySelectedRoomGuests(viewModel: RoomGuestsPickerModels.Select.ViewModel) {
		delegate?.didSelectRoomGuests(
			rooms: viewModel.rooms,
			adults: viewModel.adults,
			childrenAges: viewModel.childrenAge
		)
		dismiss(animated: true)
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

	@objc private func didApply() {
		interactor?.selectRoomGuests(request: RoomGuestsPickerModels.Select.Request())
	}
}

extension RoomGuestsPickerViewController: AgeInputViewDelegate {
	func ageInputViewDidRequestPicker(_ view: AgeInputView, index: Int) {
		interactor?.didRequestAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request(index: index))
	}
}

