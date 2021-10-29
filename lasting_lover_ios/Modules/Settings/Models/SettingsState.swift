//
//  SettingsState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import Foundation
import UNILibCore

enum Settings {
	/// sourcery: lens
	struct State: Hashable, Codable {
		let subscriptionActive: Bool
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
}
