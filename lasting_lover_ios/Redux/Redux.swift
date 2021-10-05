//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.09.2021.
//

import Foundation
import UNILibCore
import RxUNILib

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

/// sourcery: prism
enum AppAction {
  case mainModuleAction(action: MainModuleAction)
}

let appReducer = mainModuleReducer
  .lift(localStateLens: AppState.lens.mainModuleState, localActionPrism: AppAction.prism.mainModuleAction)

let appMiddleware: Middleware<AppState, AppAction> = { dispatch, getState in
  { next in
    { action in
      next(action)
    }
  }
}
