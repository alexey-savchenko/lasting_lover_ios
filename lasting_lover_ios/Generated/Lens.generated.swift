// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import UNILibCore
import RxUNILib

extension App.State {
  enum lens {
    static let settingsState = Lens<App.State, Settings.State>(
      get: { $0.settingsState },
      set: { part in 
        { whole in
          App.State.init(settingsState: part, mainModuleState: whole.mainModuleState)
        }
      }
    )
    static let mainModuleState = Lens<App.State, MainModule.State>(
      get: { $0.mainModuleState },
      set: { part in 
        { whole in
          App.State.init(settingsState: whole.settingsState, mainModuleState: part)
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
extension Discover.State {
  enum lens {
    static let data = Lens<Discover.State, Loadable<DiscoverData, HashableWrapper<Discover.Error>>>(
      get: { $0.data },
      set: { part in 
        { whole in
          Discover.State.init(data: part)
        }
      }
    )
  }
}
extension MainModule.State {
  enum lens {
    static let selectedTabIndex = Lens<MainModule.State, Int>(
      get: { $0.selectedTabIndex },
      set: { part in 
        { whole in
          MainModule.State.init(selectedTabIndex: part, discoverState: whole.discoverState)
        }
      }
    )
    static let discoverState = Lens<MainModule.State, Discover.State>(
      get: { $0.discoverState },
      set: { part in 
        { whole in
          MainModule.State.init(selectedTabIndex: whole.selectedTabIndex, discoverState: part)
        }
      }
    )
  }
}
extension Player.State {
  enum lens {
    static let playbackProgress = Lens<Player.State, Double>(
      get: { $0.playbackProgress },
      set: { part in 
        { whole in
          Player.State.init(playbackProgress: part, isPlaying: whole.isPlaying, isFavourite: whole.isFavourite, item: whole.item)
        }
      }
    )
    static let isPlaying = Lens<Player.State, Bool>(
      get: { $0.isPlaying },
      set: { part in 
        { whole in
          Player.State.init(playbackProgress: whole.playbackProgress, isPlaying: part, isFavourite: whole.isFavourite, item: whole.item)
        }
      }
    )
    static let isFavourite = Lens<Player.State, Bool>(
      get: { $0.isFavourite },
      set: { part in 
        { whole in
          Player.State.init(playbackProgress: whole.playbackProgress, isPlaying: whole.isPlaying, isFavourite: part, item: whole.item)
        }
      }
    )
    static let item = Lens<Player.State, _PlayerItem>(
      get: { $0.item },
      set: { part in 
        { whole in
          Player.State.init(playbackProgress: whole.playbackProgress, isPlaying: whole.isPlaying, isFavourite: whole.isFavourite, item: part)
        }
      }
    )
  }
}
extension Settings.State {
  enum lens {
    static let subscriptionActive = Lens<Settings.State, Bool>(
      get: { $0.subscriptionActive },
      set: { part in 
        { whole in
          Settings.State.init(subscriptionActive: part)
        }
      }
    )
  }
}
