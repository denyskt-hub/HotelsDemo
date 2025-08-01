//
//  HotelFiltersScene.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import UIKit

public protocol HotelFiltersScene: UIViewController,
	PriceRangeDelegate,
	StarRatingDelegate,
	ReviewScoreDelegate {}
