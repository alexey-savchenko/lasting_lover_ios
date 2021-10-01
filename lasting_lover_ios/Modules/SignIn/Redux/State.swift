//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import Foundation

struct AuthModuleState: Hashable {
  let mode: AuthModuleLaunchMode
  let email: String
  let password: String
}

enum AuthModuleAction {
  case modeSwitch
  case submitEmailPass
  case setEmail(value: String)
  case setPassword(value: String)
}
