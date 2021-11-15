//
//  SettingsState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib

enum Settings {
	/// sourcery: lens
	struct State: Hashable {
		let subscriptionActive: Bool
		let items: [SettingsItem]
		let notificationsEnabled: Bool
		
		static func `default`() -> Settings.State {
			return .init(
				subscriptionActive: Current.localStorageService().isSubsctiptionActive,
				items: SettingsItem.allCases,
				notificationsEnabled: false
			)
		}
	}
	
	/// sourcery: prism
	enum Action {
		case setSubscriptionActive(value: Bool)
	}
	
	static let reducer = Reducer<Settings.State, Settings.Action> { state, action in
		switch action {
		case .setSubscriptionActive(let value):
			return Settings.State.lens.subscriptionActive.set(value)(state)
		}
	}
	
	static let middleware: Middleware<Settings.State, Settings.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setSubscriptionActive:
					next(action)
				}
			}
		}
	}
}
