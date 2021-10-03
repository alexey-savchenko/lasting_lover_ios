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
	let settingsState: SettingsState
  let mainModuleState: MainModuleState
  
  static func `default`() -> AppState {
    let isSubActive = Current.localStorageService().isSubsctiptionActive
    return AppState(
      settingsState: SettingsState(
        subscriptionActive: isSubActive
      ),
      mainModuleState: MainModuleState(
        selectedTabIndex: 0
      )
    )
  }
}

enum AppAction {
  case mainModuleAction(action: MainModuleAction)
}

/// sourcery: lens
struct SettingsState: Hashable, Codable {
	let subscriptionActive: Bool
}
