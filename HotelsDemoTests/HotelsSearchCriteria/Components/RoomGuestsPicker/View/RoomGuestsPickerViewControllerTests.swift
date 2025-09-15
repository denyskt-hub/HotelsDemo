//
//  RoomGuestsPickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 8/7/25.
//

import XCTest
import HotelsDemo

final class RoomGuestsPickerViewControllerTests: XCTestCase {
	func test_viewDidLoad_requestLimitsAndRoomGuests() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [
			.doFetchLimits(.init()),
			.doFetchRoomGuests(.init())
		])
	}

	func test_applyLimits_updatesStepperBoundsWithProvidedLimits() {
		let limits = RoomGuestsLimits(
			maxRooms: 5,
			maxAdults: 10,
			maxChildren: 3
		)
		let (sut, _, _) = makeSUT()

		sut.applyLimits(limits)

		XCTAssertEqual(sut.roomsStepper.minimumValue, 1)
		XCTAssertEqual(sut.roomsStepper.maximumValue, 5)

		XCTAssertEqual(sut.adultsStepper.minimumValue, 1)
		XCTAssertEqual(sut.adultsStepper.maximumValue, 10)

		XCTAssertEqual(sut.childrenStepper.minimumValue, 0)
		XCTAssertEqual(sut.childrenStepper.maximumValue, 3)
	}

	func test_displayRoomGuests_rendersProvidedRoomGuests() {
		let viewModel = anyRoomGuestsLoadViewModel()
		let (sut, _, _) = makeSUT()

		sut.displayRoomGuests(viewModel: viewModel)

		assertThat(sut, isRendering: viewModel)
	}

	func test_displayAgePicker_presentsAgePickerWithCorrectOptions() {
		let viewModel = makeRoomGuestsAgeSelectionViewModel(
			index: 0,
			title: "Child 1",
			selectedIndex: 1,
			options: [(value: 0, title: "0"), (value: 1, title: "1")]
		)
		let sut = RoomGuestsPickerViewController()
		sut.simulateAppearanceInWindow()

		sut.displayAgePicker(viewModel: viewModel)

		assertPresented(sut, as: AgePickerViewController.self) { vc in
			XCTAssertEqual(vc.options, ["0", "1"])
			XCTAssertEqual(vc.selectedIndex, 1)
		}
	}

	func test_agePickerSelection_didSelectAge() {
		let viewModel = makeRoomGuestsAgeSelectionViewModel(
			index: 0,
			title: "Child 1",
			selectedIndex: 0,
			options: [(value: 0, title: "0"), (value: 1, title: "1"), (value: 2, title: "2")]
		)
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displayAgePicker(viewModel: viewModel)
		sut.waitForPresentation()
		sut.simulateAgeSelection(at: 2)

		XCTAssertEqual(interactor.messages.last, .handleAgeSelection(.init(index: viewModel.index, age: 2)))
	}

	func test_displayRooms_rendersProvidedNumberOfRooms() {
		let (sut, _, _) = makeSUT()

		sut.displayRooms(viewModel: .init(rooms: 2))

		XCTAssertEqual(sut.roomsStepper.value, 2)
	}

	func test_displayAdults_rendersProvidedNumberOfAdults() {
		let (sut, _, _) = makeSUT()
		
		sut.displayAdults(viewModel: .init(adults: 2))
		
		XCTAssertEqual(sut.adultsStepper.value, 2)
	}

	func test_displayUpdateChildrenAge_rendersProvidedNumberOfChildren() {
		let childrenAge = anyChildrenAgeInputViewModels()
		let (sut, _, _) = makeSUT()
		
		sut.displayUpdateChildrenAge(viewModel: .init(childrenAge: childrenAge))

		childrenAge.enumerated().forEach { index, viewModel in
			assertThat(sut, hasViewConfiguredFor: viewModel, at: index)
		}
	}

	func test_displayChildrenAge_rendersProvidedNumberOfChildren() {
		let childrenAge = anyChildrenAgeInputViewModels()
		let (sut, _, _) = makeSUT()

		sut.displayChildrenAge(viewModel: .init(childrenAge: childrenAge))

		childrenAge.enumerated().forEach { index, viewModel in
			assertThat(sut, hasViewConfiguredFor: viewModel, at: index)
		}
	}

	func test_displaySelectedRoomGuests_notifiesDelegateWithSelectedRoomGuests() {
		let (rooms, adults, childrenAge) = (1, 2, [2])
		let (sut, _, delegate) = makeSUT()

		sut.displaySelectedRoomGuests(viewModel: .init(rooms: rooms, adults: adults, childrenAge: childrenAge))

		XCTAssertEqual(delegate.messages, [.didSelectRoomGuests(rooms, adults, childrenAge)])
	}

	func test_roomsStepperDecrementTap_decrementsRooms() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateRoomsStepperDecrement()
		XCTAssertEqual(interactor.messages.last, .handleDecrementRooms)

		sut.simulateRoomsStepperDecrement()
		XCTAssertEqual(interactor.messages.suffix(2), [
			.handleDecrementRooms,
			.handleDecrementRooms
		])
	}

	func test_roomsStepperIncrementTap_incrementsRooms() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateRoomsStepperIncrement()
		XCTAssertEqual(interactor.messages.last, .handleIncrementRooms)

		sut.simulateRoomsStepperIncrement()
		XCTAssertEqual(interactor.messages.suffix(2), [
			.handleIncrementRooms,
			.handleIncrementRooms
		])
	}

	func test_adultsStepperDecrementTap_decrementsAdults() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateAdultsStepperDecrement()
		XCTAssertEqual(interactor.messages.last, .handleDecrementAdults)

		sut.simulateAdultsStepperDecrement()
		XCTAssertEqual(interactor.messages.suffix(2), [
			.handleDecrementAdults,
			.handleDecrementAdults
		])
	}

	func test_adultsStepperIncrementTap_incrementsAdults() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateAdultsStepperIncrement()
		XCTAssertEqual(interactor.messages.last, .handleIncrementAdults)

		sut.simulateAdultsStepperIncrement()
		XCTAssertEqual(interactor.messages.suffix(2), [
			.handleIncrementAdults,
			.handleIncrementAdults
		])
	}

	func test_childrenStepperStepperDecrementTap_decrementsChildrenAge() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateChildrenAgeStepperDecrement()
		XCTAssertEqual(interactor.messages.last, .handleDecrementChildrenAge)

		sut.simulateChildrenAgeStepperDecrement()
		XCTAssertEqual(interactor.messages.suffix(2), [
			.handleDecrementChildrenAge,
			.handleDecrementChildrenAge
		])
	}

	func test_childrenStepperStepperIncrementTap_incrementsChildrenAge() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateChildrenAgeStepperIncrement()
		XCTAssertEqual(interactor.messages.last, .handleIncrementChildrenAge)

		sut.simulateChildrenAgeStepperIncrement()
		XCTAssertEqual(interactor.messages.suffix(2), [
			.handleIncrementChildrenAge,
			.handleIncrementChildrenAge
		])
	}

	func test_selectAgeButtonTap_requestAgePicker() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.displayRoomGuests(viewModel: anyRoomGuestsLoadViewModel())

		sut.simulateSelectAgeButtonTap(at: 0)

		XCTAssertEqual(interactor.messages.last, .handleAgePicker(.init(index: 0)))
	}

	func test_applyButtonTap_selectsDateRange() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateApplyButtonTap()

		XCTAssertEqual(interactor.messages.last, .handleRoomGuestsSelection(.init()))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: RoomGuestsPickerViewController,
		interactor: RoomGuestsPickerBusinessLogicSpy,
		delegate: RoomGuestsPickerDelegateSpy
	) {
		let interactor = RoomGuestsPickerBusinessLogicSpy()
		let delegate = RoomGuestsPickerDelegateSpy()
		let sut = RoomGuestsPickerViewController()
		sut.interactor = interactor
		sut.delegate = delegate
		return (sut, interactor, delegate)
	}

	private func assertThat(
		_ sut: RoomGuestsPickerViewController,
		isRendering viewModel: RoomGuestsPickerModels.FetchRoomGuests.ViewModel,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertEqual(sut.roomsStepper.value, viewModel.rooms, file: file, line: line)
		XCTAssertEqual(sut.adultsStepper.value, viewModel.adults, file: file, line: line)
		XCTAssertEqual(sut.childrenStepper.value, viewModel.childrenAge.count, file: file, line: line)

		viewModel.childrenAge.enumerated().forEach { index, viewModel in
			assertThat(sut, hasViewConfiguredFor: viewModel, at: index)
		}
	}

	private func assertThat(
		_ sut: RoomGuestsPickerViewController,
		hasViewConfiguredFor viewModel: RoomGuestsPickerModels.AgeInputViewModel,
		at index: Int,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let view = sut.ageInputView(at: index)
		guard let ageInputView = view as? AgeInputView else {
			return XCTFail("Expected \(AgeInputView.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(ageInputView.title, viewModel.title, file: file, line: line)
		XCTAssertEqual(ageInputView.selectedAgeTitle, viewModel.selectedAgeTitle, file: file, line: line)
	}

	private func assertPresented<T: UIViewController>(
		_ presentingVC: UIViewController,
		as type: T.Type,
		file: StaticString = #file,
		line: UInt = #line,
		assert: (T) -> Void = { _ in }
	) {
		guard let presented = presentingVC.presentedViewController else {
			XCTFail("Expected a view controller to be presented, but none was.", file: file, line: line)
			return
		}

		if let nav = presented as? UINavigationController,
		   let first = nav.viewControllers.first as? T {
			assert(first)
		} else if let vc = presented as? T {
			assert(vc)
		} else {
			XCTFail("Expected presented controller to be of type \(T.self), got \(String(describing: presented))", file: file, line: line)
		}
	}

	private func anyChildrenAgeInputViewModels() -> [RoomGuestsPickerModels.AgeInputViewModel] {
		[
			.init(index: 0, title: "Child 1", selectedAgeTitle: "2"),
			.init(index: 0, title: "Child 2", selectedAgeTitle: "5")
		]
	}

	private func anyRoomGuestsLoadViewModel() -> RoomGuestsPickerModels.FetchRoomGuests.ViewModel {
		.init(
			rooms: 1,
			adults: 2,
			childrenAge: anyChildrenAgeInputViewModels()
		)
	}

	private func makeRoomGuestsAgeSelectionViewModel(
		index: Int,
		title: String,
		selectedIndex: Int,
		options: [(value: Int, title: String)]
	) -> RoomGuestsPickerModels.AgeSelection.ViewModel {
		.init(
			index: index,
			title: title,
			selectedIndex: selectedIndex,
			availableAges: options.map({ .init(value: $0.value, title: $0.title) })
		)
	}
}

extension AgeInputView {
	var title: String? {
		titleLabel.text
	}

	var selectedAgeTitle: String? {
		selectControl.title()
	}
}

extension RoomGuestsPickerViewController {
	func ageInputView(at index: Int) -> UIView? {
		childrenViews[index]
	}

	func simulateRoomsStepperDecrement() {
		roomsStepper.decrementButton.simulateTap()
	}

	func simulateRoomsStepperIncrement() {
		roomsStepper.incrementButton.simulateTap()
	}

	func simulateAdultsStepperDecrement() {
		adultsStepper.decrementButton.simulateTap()
	}

	func simulateAdultsStepperIncrement() {
		adultsStepper.incrementButton.simulateTap()
	}

	func simulateChildrenAgeStepperDecrement() {
		childrenStepper.decrementButton.simulateTap()
	}

	func simulateChildrenAgeStepperIncrement() {
		childrenStepper.incrementButton.simulateTap()
	}

	func simulateSelectAgeButtonTap(at index: Int) {
		let ageInputView = ageInputView(at: index) as? AgeInputView
		ageInputView?.selectControl.simulateTap()
	}

	func simulateAgeSelection(at index: Int) {
		let agePicker = presentedViewController as? AgePickerViewController
		agePicker?.pickerView.selectRow(index, inComponent: 0, animated: false)
		agePicker?.doneButton.simulateTap()
	}

	func simulateApplyButtonTap() {
		applyButton.simulateTap()
	}
}

final class RoomGuestsPickerBusinessLogicSpy: RoomGuestsPickerBusinessLogic {
	enum Message: Equatable {
		case doFetchLimits(RoomGuestsPickerModels.FetchLimits.Request)
		case doFetchRoomGuests(RoomGuestsPickerModels.FetchRoomGuests.Request)
		case handleDecrementRooms
		case handleIncrementRooms
		case handleDecrementAdults
		case handleIncrementAdults
		case handleDecrementChildrenAge
		case handleIncrementChildrenAge
		case handleAgePicker(RoomGuestsPickerModels.AgeSelection.Request)
		case handleAgeSelection(RoomGuestsPickerModels.AgeSelected.Request)
		case handleRoomGuestsSelection(RoomGuestsPickerModels.Select.Request)
	}

	private(set) var messages = [Message]()

	func doFetchLimits(request: RoomGuestsPickerModels.FetchLimits.Request) {
		messages.append(.doFetchLimits(request))
	}
	
	func doFetchRoomGuests(request: RoomGuestsPickerModels.FetchRoomGuests.Request) {
		messages.append(.doFetchRoomGuests(request))
	}
	
	func handleDecrementRooms() {
		messages.append(.handleDecrementRooms)
	}
	
	func handleIncrementRooms() {
		messages.append(.handleIncrementRooms)
	}
	
	func handleDecrementAdults() {
		messages.append(.handleDecrementAdults)
	}
	
	func handleIncrementAdults() {
		messages.append(.handleIncrementAdults)
	}
	
	func handleDecrementChildrenAge() {
		messages.append(.handleDecrementChildrenAge)
	}
	
	func handleIncrementChildrenAge() {
		messages.append(.handleIncrementChildrenAge)
	}
	
	func handleAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request) {
		messages.append(.handleAgePicker(request))
	}
	
	func handleAgeSelection(request: RoomGuestsPickerModels.AgeSelected.Request) {
		messages.append(.handleAgeSelection(request))
	}
	
	func handleRoomGuestsSelection(request: RoomGuestsPickerModels.Select.Request) {
		messages.append(.handleRoomGuestsSelection(request))
	}
}

final class RoomGuestsPickerDelegateSpy: RoomGuestsPickerDelegate {
	enum Message: Equatable {
		case didSelectRoomGuests(Int, Int, [Int])
	}

	private(set) var messages = [Message]()

	func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		messages.append(.didSelectRoomGuests(rooms, adults, childrenAges))
	}
}
