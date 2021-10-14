//
//  PlayerModuleState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib

enum Player {
  
  static let mockStore = RxStore<Player.State, Player.Action>(inputState: .mock, middleware: [], reducer: Player.reducer)
  
  /// sourcery: lens
  struct State: Hashable {
    let isPlaying: Bool
    let isFavourite: Bool
    let item: PlayerItem
    
    static let mock = State(isPlaying: false, isFavourite: false, item: .mock)
  }
  
  /// sourcery: prism
  enum Action {
    case playTap
    case favoriteTap
  }
  
  static let reducer = Reducer<Player.State, Player.Action> { state, action in
    switch action {
    case .playTap:
      return Player.State.lens.isPlaying.set(!state.isPlaying)(state)
    case .favoriteTap:
      return Player.State.lens.isFavourite.set(!state.isFavourite)(state)
    }
  }
}
