//
//  RoomGuestsPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public protocol RoomGuestsPickerDelegate: AnyObject {

}

public protocol RoomGuestsPickerDisplayLogic: AnyObject {
	func applyLimits(_ limits: RoomGuestsLimits)
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

		interactor?.loadRoomGuestsLimits(request: RoomGuestsPickerModels.LoadLimits.Request())
	}

	public func applyLimits(_ limits: RoomGuestsLimits) {
		rootView.roomsStepper.setRange(minimumValue: 1, maximumValue: limits.maxRooms)
		rootView.adultsStepper.setRange(minimumValue: 1, maximumValue: limits.maxAdults)
		rootView.childrenStepper.setRange(minimumValue: 0, maximumValue: limits.maxChildren)
	}
}
