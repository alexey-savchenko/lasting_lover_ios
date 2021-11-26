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
extension DiscoverTab.State {
  enum lens {
    static let data = Lens<DiscoverTab.State, Loadable<DiscoverData, HashableWrapper<AppError>>>(
      get: { $0.data },
      set: { part in 
        { whole in
          DiscoverTab.State.init(data: part, authorStories: whole.authorStories, seriesStories: whole.seriesStories, categoryStories: whole.categoryStories, allStories: whole.allStories)
        }
      }
    )
    static let authorStories = Lens<DiscoverTab.State, [Author: Loadable<[Story], HashableWrapper<AppError>>]>(
      get: { $0.authorStories },
      set: { part in 
        { whole in
          DiscoverTab.State.init(data: whole.data, authorStories: part, seriesStories: whole.seriesStories, categoryStories: whole.categoryStories, allStories: whole.allStories)
        }
      }
    )
    static let seriesStories = Lens<DiscoverTab.State, [Series: Loadable<[Story], HashableWrapper<AppError>>]>(
      get: { $0.seriesStories },
      set: { part in 
        { whole in
          DiscoverTab.State.init(data: whole.data, authorStories: whole.authorStories, seriesStories: part, categoryStories: whole.categoryStories, allStories: whole.allStories)
        }
      }
    )
    static let categoryStories = Lens<DiscoverTab.State, [Category: Loadable<[Story], HashableWrapper<AppError>>]>(
      get: { $0.categoryStories },
      set: { part in 
        { whole in
          DiscoverTab.State.init(data: whole.data, authorStories: whole.authorStories, seriesStories: whole.seriesStories, categoryStories: part, allStories: whole.allStories)
        }
      }
    )
    static let allStories = Lens<DiscoverTab.State, Loadable<[Story], HashableWrapper<AppError>>>(
      get: { $0.allStories },
      set: { part in 
        { whole in
          DiscoverTab.State.init(data: whole.data, authorStories: whole.authorStories, seriesStories: whole.seriesStories, categoryStories: whole.categoryStories, allStories: part)
        }
      }
    )
  }
}
extension FavoritesTab.State {
  enum lens {
    static let items = Lens<FavoritesTab.State, [Story]>(
      get: { $0.items },
      set: { part in 
        { whole in
          FavoritesTab.State.init(items: part)
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
          MainModule.State.init(selectedTabIndex: part, discoverState: whole.discoverState, sleepState: whole.sleepState, favoritesState: whole.favoritesState)
        }
      }
    )
    static let discoverState = Lens<MainModule.State, DiscoverTab.State>(
      get: { $0.discoverState },
      set: { part in 
        { whole in
          MainModule.State.init(selectedTabIndex: whole.selectedTabIndex, discoverState: part, sleepState: whole.sleepState, favoritesState: whole.favoritesState)
        }
      }
    )
    static let sleepState = Lens<MainModule.State, SleepTab.State>(
      get: { $0.sleepState },
      set: { part in 
        { whole in
          MainModule.State.init(selectedTabIndex: whole.selectedTabIndex, discoverState: whole.discoverState, sleepState: part, favoritesState: whole.favoritesState)
        }
      }
    )
    static let favoritesState = Lens<MainModule.State, FavoritesTab.State>(
      get: { $0.favoritesState },
      set: { part in 
        { whole in
          MainModule.State.init(selectedTabIndex: whole.selectedTabIndex, discoverState: whole.discoverState, sleepState: whole.sleepState, favoritesState: part)
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
    static let item = Lens<Player.State, Story>(
      get: { $0.item },
      set: { part in 
        { whole in
          Player.State.init(playbackProgress: whole.playbackProgress, isPlaying: whole.isPlaying, isFavourite: whole.isFavourite, item: part)
        }
      }
    )
  }
}
extension PurchaseModule.State {
  enum lens {
    static let isLoading = Lens<PurchaseModule.State, Bool>(
      get: { $0.isLoading },
      set: { part in 
        { whole in
          PurchaseModule.State.init(isLoading: part, origin: whole.origin, selectedIAP: whole.selectedIAP, dismiss: whole.dismiss)
        }
      }
    )
    static let origin = Lens<PurchaseModule.State, PurchaseScreenOrigin>(
      get: { $0.origin },
      set: { part in 
        { whole in
          PurchaseModule.State.init(isLoading: whole.isLoading, origin: part, selectedIAP: whole.selectedIAP, dismiss: whole.dismiss)
        }
      }
    )
    static let selectedIAP = Lens<PurchaseModule.State, IAP?>(
      get: { $0.selectedIAP },
      set: { part in 
        { whole in
          PurchaseModule.State.init(isLoading: whole.isLoading, origin: whole.origin, selectedIAP: part, dismiss: whole.dismiss)
        }
      }
    )
    static let dismiss = Lens<PurchaseModule.State, Bool>(
      get: { $0.dismiss },
      set: { part in 
        { whole in
          PurchaseModule.State.init(isLoading: whole.isLoading, origin: whole.origin, selectedIAP: whole.selectedIAP, dismiss: part)
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
          Settings.State.init(subscriptionActive: part, items: whole.items, notificationsEnabled: whole.notificationsEnabled)
        }
      }
    )
    static let items = Lens<Settings.State, [SettingsItem]>(
      get: { $0.items },
      set: { part in 
        { whole in
          Settings.State.init(subscriptionActive: whole.subscriptionActive, items: part, notificationsEnabled: whole.notificationsEnabled)
        }
      }
    )
    static let notificationsEnabled = Lens<Settings.State, Bool>(
      get: { $0.notificationsEnabled },
      set: { part in 
        { whole in
          Settings.State.init(subscriptionActive: whole.subscriptionActive, items: whole.items, notificationsEnabled: part)
        }
      }
    )
  }
}
extension SleepData {
  enum lens {
    static let categories = Lens<SleepData, [Category]>(
      get: { $0.categories },
      set: { part in 
        { whole in
          SleepData.init(categories: part, featuredStories: whole.featuredStories)
        }
      }
    )
    static let featuredStories = Lens<SleepData, [Story]>(
      get: { $0.featuredStories },
      set: { part in 
        { whole in
          SleepData.init(categories: whole.categories, featuredStories: part)
        }
      }
    )
  }
}
extension SleepTab.State {
  enum lens {
    static let data = Lens<SleepTab.State, Loadable<SleepData, HashableWrapper<AppError>>>(
      get: { $0.data },
      set: { part in 
        { whole in
          SleepTab.State.init(data: part, sleepStories: whole.sleepStories, categoryStories: whole.categoryStories)
        }
      }
    )
    static let sleepStories = Lens<SleepTab.State, Loadable<[Story], HashableWrapper<AppError>>>(
      get: { $0.sleepStories },
      set: { part in 
        { whole in
          SleepTab.State.init(data: whole.data, sleepStories: part, categoryStories: whole.categoryStories)
        }
      }
    )
    static let categoryStories = Lens<SleepTab.State, [Category: Loadable<[Story], HashableWrapper<AppError>>]>(
      get: { $0.categoryStories },
      set: { part in 
        { whole in
          SleepTab.State.init(data: whole.data, sleepStories: whole.sleepStories, categoryStories: part)
        }
      }
    )
  }
}
