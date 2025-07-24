//
//  HotelsFilterPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public protocol HotelsFilterPickerPresentationLogic {
	func presentLoad(response: HotelsFilterPickerModels.Load.Response)
	func presentSelectedFilter(response: HotelsFilterPickerModels.Select.Response)
	func presentResetFilter(response: HotelsFilterPickerModels.Reset.Response)
}
