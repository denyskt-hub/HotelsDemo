//
//  DateRangePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

protocol DateRangePickerDisplayLogic: AnyObject {

}

public final class DateRangePickerViewController: NiblessViewController, DateRangePickerDisplayLogic {
	private let rootView = DateRangePickerRootView()

	var interactor: DateRangePickerBusinessLogic?

	override public func loadView() {
		view = rootView
	}
}
