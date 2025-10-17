//
//  RoomGuestsPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import UIKit

public final class RoomGuestsPickerViewController: NiblessViewController, RoomGuestsPickerDisplayLogic {
	private let interactor: RoomGuestsPickerBusinessLogic
	private weak var delegate: RoomGuestsPickerDelegate?

	private let rootView = RoomGuestsPickerRootView()

	public var roomsStepper: StepperView { rootView.roomsStepper }
	public var adultsStepper: StepperView { rootView.adultsStepper }
	public var childrenStepper: StepperView { rootView.childrenStepper }
	public var childrenViews: [UIView] { rootView.childrenStack.arrangedSubviews }
	public var applyButton: UIButton { rootView.applyButton }

	public init(
		interactor: RoomGuestsPickerBusinessLogic,
		delegate: RoomGuestsPickerDelegate?
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

		setupRoomsStepper()
		setupAdultsStepper()
		setupChildrenStepper()
		setupApplyButton()

		interactor.doFetchLimits(request: RoomGuestsPickerModels.FetchLimits.Request())
		interactor.doFetchRoomGuests(request: RoomGuestsPickerModels.FetchRoomGuests.Request())
	}

	private func setupRoomsStepper() {
		roomsStepper.decrementButton.addTarget(self, action: #selector(didDecrementRooms), for: .touchUpInside)
		roomsStepper.incrementButton.addTarget(self, action: #selector(didIncrementRooms), for: .touchUpInside)
	}

	private func setupAdultsStepper() {
		adultsStepper.decrementButton.addTarget(self, action: #selector(didDecrementAdults), for: .touchUpInside)
		adultsStepper.incrementButton.addTarget(self, action: #selector(didIncrementAdults), for: .touchUpInside)
	}

	private func setupChildrenStepper() {
		childrenStepper.decrementButton.addTarget(self, action: #selector(didDecrementChildren), for: .touchUpInside)
		childrenStepper.incrementButton.addTarget(self, action: #selector(didIncrementChildren), for: .touchUpInside)
	}

	private func setupApplyButton() {
		applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
	}

	public func applyLimits(_ limits: RoomGuestsLimits) {
		roomsStepper.setRange(minimumValue: 1, maximumValue: limits.maxRooms)
		adultsStepper.setRange(minimumValue: 1, maximumValue: limits.maxAdults)
		childrenStepper.setRange(minimumValue: 0, maximumValue: limits.maxChildren)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.FetchRoomGuests.ViewModel) {
		roomsStepper.setValue(viewModel.rooms)
		adultsStepper.setValue(viewModel.adults)
		displayChildrenAge(viewModel.childrenAge)
	}

	public func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel) {
		roomsStepper.setValue(viewModel.rooms)
	}

	public func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel) {
		adultsStepper.setValue(viewModel.adults)
	}

	public func displayUpdateChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel) {
		displayChildrenAge(viewModel.childrenAge)
	}

	public func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel) {
		displayChildrenAge(viewModel.childrenAge)
	}

	private func displayChildrenAge(_ childrenAge: [RoomGuestsPickerModels.AgeInputViewModel]) {
		childrenStepper.setValue(childrenAge.count)

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
			self?.interactor.handleAgeSelection(request: .init(index: index, age: age))
		}
		vc.title = viewModel.title

		if let sheet = vc.sheetPresentationController {
			sheet.detents = [.custom(resolver: { _ in 344 })]
			sheet.prefersGrabberVisible = true
		}

		present(vc, animated: true)
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
		interactor.handleDecrementRooms()
	}

	@objc private func didIncrementRooms() {
		interactor.handleIncrementRooms()
	}

	@objc private func didDecrementAdults() {
		interactor.handleDecrementAdults()
	}

	@objc private func didIncrementAdults() {
		interactor.handleIncrementAdults()
	}

	@objc private func didDecrementChildren() {
		interactor.handleDecrementChildrenAge()
	}

	@objc private func didIncrementChildren() {
		interactor.handleIncrementChildrenAge()
	}

	@objc private func didApply() {
		interactor.handleRoomGuestsSelection(request: RoomGuestsPickerModels.Select.Request())
	}
}

extension RoomGuestsPickerViewController: AgeInputViewDelegate {
	public func ageInputViewDidRequestPicker(_ view: AgeInputView, index: Int) {
		interactor.handleAgePicker(request: .init(index: index))
	}
}
