//
//  Environment.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation

public enum Environment {
	enum Keys {
		static let apiKey = "API_KEY"
		static let apiHost = "API_HOST"
	}

	private static let infoDictionary: [String: Any] = {
		guard let dict = Bundle.main.infoDictionary else {
			fatalError("Could not load info dictionary")
		}
		return dict
	}()

	public static let apiKey: String = {
		guard let apiKey = infoDictionary[Keys.apiKey] as? String else {
			fatalError("API key not found in info.plist")
		}
		return apiKey
	}()

	public static let apiHost: String = {
		guard let apiHost = infoDictionary[Keys.apiHost] as? String else {
			fatalError("API host not found in info.plist")
		}
		return apiHost
	}()
}
