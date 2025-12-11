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

@MainActor
public final class RoomGuestsPickerComposer: RoomGuestsPickerFactory {
	public func makeRoomGuestsPicker(
		delegate: RoomGuestsPickerDelegate?,
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) -> UIViewController {
		let viewControllerProxy = WeakRefVirtualProxy<RoomGuestsPickerViewController>()

		let presenter = RoomGuestsPickerPresenter(
			viewController: viewControllerProxy
		)

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

		viewControllerProxy.object = viewController
		return viewController
	}
}
