//
//  RoomGuestsPickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import UIKit

public protocol RoomGuestsPickerFactory {
	func makeRoomGuestsPicker(
		delegate: RoomGuestsPickerDelegate?,
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) -> UIViewController
}

public final class RoomGuestsPickerComposer: RoomGuestsPickerFactory {
	public func makeRoomGuestsPicker(
		delegate: RoomGuestsPickerDelegate?,
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) -> UIViewController {
		let presenter = RoomGuestsPickerPresenter()
		let interactor = RoomGuestsPickerInteractor(
			rooms: rooms,
			adults: adults,
			childrenAge: childrenAge,
			presenter: presenter
		)
		let viewController = RoomGuestsPickerViewController(
			interactor: interactor,
			delegate: delegate
		)

		presenter.viewController = viewController

		return viewController
	}
}
