//
//  SettingsState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import UIKit

enum Settings {
	/// sourcery: lens
	struct State: Hashable {
		let subscriptionActive: Bool
		let items: [SettingsItem]
		let notificationsEnabled: Bool
		
		static func `default`() -> Settings.State {
			return .init(
				subscriptionActive: Current.subscriptionService().subscriptionActive,
				items: SettingsItem.allCases,
				notificationsEnabled: false
			)
		}
	}
	
	/// sourcery: prism
	enum Action {
		case setSubscriptionActive(value: Bool)
		case setNotificationsActive(value: Bool)
		case openAppSettings
	}
	
	static let reducer = Reducer<Settings.State, Settings.Action> { state, action in
		switch action {
		case .openAppSettings:
			return state
		case .setNotificationsActive(let value):
			return Settings.State.lens.notificationsEnabled.set(value)(state)
		case .setSubscriptionActive(let value):
			return Settings.State.lens.subscriptionActive.set(value)(state)
		}
	}
	
	static let middleware: Middleware<Settings.State, Settings.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .openAppSettings:
					UIApplication.shared.open(
						URL(string: UIApplication.openSettingsURLString)!,
						options: [:]
					)
				case .setSubscriptionActive,
						.setNotificationsActive:
					next(action)
				}
			}
		}
	}
}
