//
//  DestinationPickerDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol DestinationPickerDelegate: AnyObject {
	func didSelectDestination(_ destination: Destination)
}
