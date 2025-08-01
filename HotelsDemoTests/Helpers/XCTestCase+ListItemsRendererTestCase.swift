//
//  XCTestCase+ListItemsRendererTestCase.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest

protocol ListItemsRendererTestCase {}

extension ListItemsRendererTestCase where Self: XCTestCase {
	func assertThat<ViewModel>(
		_ renderer: ListItemsRenderer,
		isRendering viewModels: [ViewModel],
		assert: (UIView?, ViewModel, Int) -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		guard renderer.numberOfRenderedItems() == viewModels.count else {
			return XCTFail("Expect \(viewModels.count) items, got \(renderer.numberOfRenderedItems()) instead", file: file, line: line)
		}

		viewModels.enumerated().forEach { index, viewModel in
			let view = renderer.view(at: index)
			assert(view, viewModel, index)
		}
	}
}
