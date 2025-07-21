//
//  HotelsFilterPickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public protocol HotelsFilterPickerDisplayLogic: AnyObject {
	func displayLoad(viewModel: HotelsFilterPickerModels.Load.ViewModel)
}
