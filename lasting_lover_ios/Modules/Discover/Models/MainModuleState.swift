//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import Foundation

/// sourcery: lens
struct MainModuleState: Hashable {
  let selectedTabIndex: Int
}

enum MainModuleAction {
  case setTabIndex(value: Int)
}
