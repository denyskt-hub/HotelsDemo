//
//  CharacterSet+StrictQueryValueAllowed.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import Foundation

public extension CharacterSet {
	static let strictQueryValueAllowed: CharacterSet = {
		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "!*'();:@&=+$,/?%#[]\" ")
		return allowed
	}()
}
