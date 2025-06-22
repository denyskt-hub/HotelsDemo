//
//  DateRangePickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public protocol DateRangePickerPresentationLogic {

}

public final class DataRangePickerPresenter: DateRangePickerPresentationLogic {
	weak var viewController: DateRangePickerDisplayLogic?
}
