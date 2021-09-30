//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.09.2021.
//

import Foundation
import UNILibCore

typealias Trigger = IdentifiedBox<_Void>?

/// sourcery: lens
struct AppState: Hashable {
	let profileState: SettingsState
  let loginState: LoginState
  let logoutTrigger: Trigger
}

/// sourcery: lens
struct LoginState: Hashable {
  
}

/// sourcery: lens
struct SettingsState: Hashable, Codable {
	let subscriptionActive: Bool
}
