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

	func test_selectFilters_presentsSelectedFilters() {
		let (sut, presenter) = makeSUT(currentFilters: anyHotelFilters())
		
		sut.selectFilters(request: .init())
		
		XCTAssertEqual(presenter.messages, [
			.presentSelectedFilters(.init(filters: anyHotelFilters()))
		])
	}

	// MARK: - Helpers

	private func makeSUT(currentFilters: HotelFilters) -> (
		sut: HotelFiltersPickerInteractor,
		presenter: HotelFiltersPickerPresentationLogicSpy
	) {
		let presenter = HotelFiltersPickerPresentationLogicSpy()
		let sut = HotelFiltersPickerInteractor(currentFilters: currentFilters)
		sut.presenter = presenter
		return (sut, presenter)
	}

	private func anyHotelFilters() -> HotelFilters {
		HotelFilters()
	}
}

final class HotelFiltersPickerPresentationLogicSpy: HotelFiltersPickerPresentationLogic {
	enum Message: Equatable {
		case presentSelectedFilters(HotelFiltersPickerModels.Select.Response)
		case presentResetFilters(HotelFiltersPickerModels.Reset.Response)
	}

	private(set) var messages = [Message]()

	func presentSelectedFilters(response: HotelFiltersPickerModels.Select.Response) {
		messages.append(.presentSelectedFilters(response))
	}
	
	func presentResetFilters(response: HotelFiltersPickerModels.Reset.Response) {
		messages.append(.presentResetFilters(response))
	}
}
