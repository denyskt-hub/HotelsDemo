//
//  HotelsSearchCriteriaScene.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/7/25.
//

import UIKit

public protocol HotelsSearchCriteriaScene: Routable,
	DestinationPickerDelegate,
	DateRangePickerDelegate,
	RoomGuestsPickerDelegate {}
