//
//  PlayerModuleState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import AVFoundation
import MediaPlayer

enum Player {
  
  static let mockStore: RxStore<Player.State, Player.Action> = {
    let s = RxStore<Player.State, Player.Action>(
      inputState: .mock,
      middleware: [Player.middleware],
      reducer: Player.reducer
    )
    
    s.attach(Player.Plugin.isPlayingPlugin)
    s.attach(Player.Plugin.playbackProgressPlugin)
    return s
  }()
  
  /// sourcery: lens
  struct State: Hashable {
    let playbackProgress: Double
    let isPlaying: Bool
    let isFavourite: Bool
    let item: PlayerItem
    
    static let mock = State(playbackProgress: 0, isPlaying: false, isFavourite: false, item: .mock)
    
    static func `default`(item: PlayerItem) -> State {
      return State(
        playbackProgress: 0,
        isPlaying: false,
        isFavourite: Current.favoritesService().favoriteItems().contains(item),
        item: item
      )
    }
  }
  
  /// sourcery: prism
  enum Action {
    case playTap
    case favoriteTap
    case initializePlayerWithItem
    case setIsPlaying(value: Bool)
    case seekToProgress(value: Double)
    case setPlaybackProgress(value: Double)
    case fwdSeek
    case bcwdSeek
		case forcePausePlayback
  }
  
  static let middleware: Middleware<Player.State, Player.Action> = { dispatch, getState in
    { next in
      { action in
        switch action {
				case .forcePausePlayback:
					Current.playerService().pause()
					
					let audioSession = AVAudioSession.sharedInstance()
					do {
						try audioSession.setCategory(.ambient)
					}
					catch {
						print("Setting category to AVAudioSessionCategoryPlayback failed.")
					}
					
					next(action)
        case .bcwdSeek:
          Current.playerService().seekBackward(offset: 15)
          next(action)
        case .fwdSeek:
          Current.playerService().seekForward(offset: 15)
          next(action)
        case .setPlaybackProgress:
          guard !Current.playerService().seeking else { return }
          next(action)
        case .seekToProgress(let value):
          Current.playerService().setPlaybackProgress(value)
          next(action)
        case .setIsPlaying:
          next(action)
        case .playTap:
          guard let state = getState() else { return }
          if state.isPlaying {
            Current.playerService().pause()
          } else {
            Current.playerService().play()
          }
          next(action)
        case .favoriteTap:
          guard let state = getState() else { return }
          if state.isFavourite {
            Current.favoritesService().removeFavorite(state.item)
          } else {
            Current.favoritesService().addFavorite(state.item)
          }
          next(action)
        case .initializePlayerWithItem:
          guard let state = getState() else { return }
          Current.playerService().setItem(state.item)
					Current.listentedItemsService().setListened(state.item.id)
          dispatch(.playTap)
        }
      }
    }
  }
  
  static let reducer = Reducer<Player.State, Player.Action> { state, action in
    switch action {
    case .setPlaybackProgress(let value):
			guard !value.isNaN else { return state } 
			let clamped = value.clamped(min: 0, max: 1)
      return Player.State.lens.playbackProgress.set(clamped)(state)
    case .setIsPlaying(let value):
      return Player.State.lens.isPlaying.set(value)(state)
    case .favoriteTap:
      return Player.State.lens.isFavourite.set(!state.isFavourite)(state)
		case .initializePlayerWithItem, .fwdSeek, .bcwdSeek, .playTap, .seekToProgress, .forcePausePlayback:
      return state
    }
  }
  
  enum Plugin {
    static let isPlayingPlugin: RxIndependentPlugin<Player.State, Player.Action> = { store in
      return Current.playerService().isPlaying.bind { value in
        store?.dispatch(.setIsPlaying(value: value))
      }
    }
    static let playbackProgressPlugin: RxIndependentPlugin<Player.State, Player.Action> = { store in
      return Current.playerService().playbackProgress.bind { value in
        store?.dispatch(.setPlaybackProgress(value: value))
      }
    }
  }
}
