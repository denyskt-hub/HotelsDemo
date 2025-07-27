//
//  HotelFiltersPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersPickerInteractorTests: XCTestCase {
	func test_init_doesNotMessagePresenter() {
		let (_, presenter) = makeSUT(currentFilters: anyHotelFilters())

		XCTAssertTrue(presenter.messages.isEmpty)
	}
	
	// MARK: - Helpers

	private func makeSUT(currentFilters: HotelsFilter) -> (
		sut: HotelFiltersPickerInteractor,
		presenter: HotelFiltersPickerPresentationLogicSpy
	) {
		let presenter = HotelFiltersPickerPresentationLogicSpy()
		let sut = HotelFiltersPickerInteractor(currentFilter: currentFilters)
		sut.presenter = presenter
		return (sut, presenter)
	}

	private func anyHotelFilters() -> HotelsFilter {
		HotelsFilter()
	}
}

final class HotelFiltersPickerPresentationLogicSpy: HotelFiltersPickerPresentationLogic {
	enum Message {
		case presentSelectedFilter(HotelFiltersPickerModels.Select.Response)
		case presentResetFilter(HotelFiltersPickerModels.Reset.Response)
	}

	private(set) var messages = [Message]()

	func presentSelectedFilter(response: HotelFiltersPickerModels.Select.Response) {
		messages.append(.presentSelectedFilter(response))
	}
	
	func presentResetFilter(response: HotelFiltersPickerModels.Reset.Response) {
		messages.append(.presentResetFilter(response))
	}
}
