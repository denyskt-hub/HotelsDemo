//
//  RoomGuestsPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

protocol RoomGuestsPickerDelegate: AnyObject {

}

protocol RoomGuestsPickerDisplayLogic: AnyObject {

}

final class RoomGuestsPickerViewController: NiblessViewController, RoomGuestsPickerDisplayLogic {
	private let rootView = RoomGuestsPickerRootView()

	var interactor: RoomGuestsPickerBusinessLogic?
	weak var delegate: RoomGuestsPickerDelegate?

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
	}
}
