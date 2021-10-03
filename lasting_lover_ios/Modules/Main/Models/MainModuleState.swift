//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import Foundation
import UNILibCore

/// sourcery: lens
struct MainModuleState: Hashable {
  let selectedTabIndex: Int
}

enum MainModuleAction {
  case setTabIndex(value: Int)
}

let mainModuleReducer = Reducer<MainModuleState, MainModuleAction> { state, action in
  switch action {
  case .setTabIndex(let value):
    return MainModuleState.lens.selectedTabIndex.set(value)(state)
  }
}
