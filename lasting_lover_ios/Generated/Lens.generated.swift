// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import UNILibCore
import RxUNILib

extension AppState {
  enum lens {
    static let settingsState = Lens<AppState, SettingsState>(
      get: { $0.settingsState },
      set: { part in 
        { whole in
          AppState.init(settingsState: part, mainModuleState: whole.mainModuleState)
        }
      }
    )
    static let mainModuleState = Lens<AppState, MainModuleState>(
      get: { $0.mainModuleState },
      set: { part in 
        { whole in
          AppState.init(settingsState: whole.settingsState, mainModuleState: part)
        }
      }
    )
  }
}
extension Auth.State {
  enum lens {
    static let mode = Lens<Auth.State, AuthModuleLaunchMode>(
      get: { $0.mode },
      set: { part in 
        { whole in
          Auth.State.init(mode: part, email: whole.email, password: whole.password, isLoading: whole.isLoading)
        }
      }
    )
    static let email = Lens<Auth.State, String>(
      get: { $0.email },
      set: { part in 
        { whole in
          Auth.State.init(mode: whole.mode, email: part, password: whole.password, isLoading: whole.isLoading)
        }
      }
    )
    static let password = Lens<Auth.State, String>(
      get: { $0.password },
      set: { part in 
        { whole in
          Auth.State.init(mode: whole.mode, email: whole.email, password: part, isLoading: whole.isLoading)
        }
      }
    )
    static let isLoading = Lens<Auth.State, Bool>(
      get: { $0.isLoading },
      set: { part in 
        { whole in
          Auth.State.init(mode: whole.mode, email: whole.email, password: whole.password, isLoading: part)
        }
      }
    )
  }
}
extension MainModuleState {
  enum lens {
    static let selectedTabIndex = Lens<MainModuleState, Int>(
      get: { $0.selectedTabIndex },
      set: { part in 
        { whole in
          MainModuleState.init(selectedTabIndex: part)
        }
      }
    )
  }
}
extension Player.State {
  enum lens {
    static let isPlaying = Lens<Player.State, Bool>(
      get: { $0.isPlaying },
      set: { part in 
        { whole in
          Player.State.init(isPlaying: part, isFavourite: whole.isFavourite, item: whole.item)
        }
      }
    )
    static let isFavourite = Lens<Player.State, Bool>(
      get: { $0.isFavourite },
      set: { part in 
        { whole in
          Player.State.init(isPlaying: whole.isPlaying, isFavourite: part, item: whole.item)
        }
      }
    )
    static let item = Lens<Player.State, PlayerItem>(
      get: { $0.item },
      set: { part in 
        { whole in
          Player.State.init(isPlaying: whole.isPlaying, isFavourite: whole.isFavourite, item: part)
        }
      }
    )
  }
}
extension SettingsState {
  enum lens {
    static let subscriptionActive = Lens<SettingsState, Bool>(
      get: { $0.subscriptionActive },
      set: { part in 
        { whole in
          SettingsState.init(subscriptionActive: part)
        }
      }
    )
  }
}
