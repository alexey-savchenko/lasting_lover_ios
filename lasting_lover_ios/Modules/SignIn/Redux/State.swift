//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib

enum Auth {
  /// sourcery: lens
  struct State: Hashable {
    let mode: AuthModuleLaunchMode
    let email: String
    let password: String
    let isLoading: Bool

    static func `default`(mode: AuthModuleLaunchMode) -> Auth.State {
      return Auth.State(mode: mode, email: "", password: "", isLoading: false)
    }
  }

  enum Action {
    case setMode(value: AuthModuleLaunchMode)
    case submitEmailPass
    case setEmail(value: String)
    case setPassword(value: String)
  }

  static let reducer = Reducer<Auth.State, Auth.Action> { state, action in
    switch action {
    case .setMode(let value):
      return Auth.State.lens.mode.set(value)(state)
    case .setEmail(let value):
      return Auth.State.lens.email.set(value)(state)
    case .setPassword(let value):
      return Auth.State.lens.password.set(value)(state)
    case .submitEmailPass:
      return state
    }
  }

  static let middleware: Middleware<Auth.State, Auth.Action> = { dispatch, getState in
    { next in
      { action in
        next(action)
      }
    }
  }
}
