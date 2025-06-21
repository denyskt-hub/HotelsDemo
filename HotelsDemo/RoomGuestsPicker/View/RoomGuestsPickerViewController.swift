//
//  RoomGuestsPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import UIKit

public protocol RoomGuestsPickerDelegate: AnyObject {

}

public protocol RoomGuestsPickerDisplayLogic: AnyObject {
	func applyLimits(_ limits: RoomGuestsLimits)
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel)

	func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel)
	func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel)
	func displayChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel)

	func displayAgePicker(viewModel: RoomGuestsPickerModels.AgeSelection.ViewModel)
	func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel)
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

		rootView.childrenStack.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		for ageViewModel in viewModel.childrenAge {
			let inputView = AgeInputView(viewModel: ageViewModel)
			inputView.delegate = self
			rootView.childrenStack.addArrangedSubview(inputView)
		}
	}

	public func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel) {
		rootView.childrenStepper.setValue(viewModel.children)

		rootView.childrenStack.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		for ageViewModel in viewModel.childrenAge {
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

extension RoomGuestsPickerViewController: AgeInputViewDelegate {
	func ageInputViewDidRequestPicker(_ view: AgeInputView, index: Int) {
		interactor?.didRequestAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request(index: index))
	}
}

final class AgePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	private let options: [String]
	private var selectedIndex: Int?
	private let onSelect: (Int) -> Void

	private let pickerView = UIPickerView()

	init(
		options: [String],
		selectedIndex: Int?,
		onSelect: @escaping (Int) -> Void
	) {
		self.options = options
		self.selectedIndex = selectedIndex
		self.onSelect = onSelect
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground

		pickerView.dataSource = self
		pickerView.delegate = self
		view.addSubview(pickerView)
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])

		if let selectedIndex {
			pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
		}

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(doneTapped)
		)
	}

	@objc private func doneTapped() {
		let selectedRow = pickerView.selectedRow(inComponent: 0)
		onSelect(selectedRow)
		dismiss(animated: true)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		options.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		options[row]
	}
}
