// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import UNILibCore
import RxUNILib




extension App.Action {
    internal enum prism {
        internal static let mainModuleAction = Prism<App.Action,MainModule.Action>(
            tryGet: { if case .mainModuleAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .mainModuleAction(action:x1) })

        internal static let settingsAction = Prism<App.Action,Settings.Action>(
            tryGet: { if case .settingsAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .settingsAction(action:x1) })

        internal static let requestNotificationAccess = Prism<App.Action, ()>(
            tryGet: { if case .requestNotificationAccess = $0 { return () } else { return nil } },
            inject: { .requestNotificationAccess })

        internal static let applicationDidBecomeActive = Prism<App.Action, ()>(
            tryGet: { if case .applicationDidBecomeActive = $0 { return () } else { return nil } },
            inject: { .applicationDidBecomeActive })

        internal static let didFinishLaunchingWithOptions = Prism<App.Action, ()>(
            tryGet: { if case .didFinishLaunchingWithOptions = $0 { return () } else { return nil } },
            inject: { .didFinishLaunchingWithOptions })

        internal static let didReceivePushToken = Prism<App.Action,String>(
            tryGet: { if case .didReceivePushToken(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .didReceivePushToken(value:x1) })

    }
}



extension DiscoverTab.Action {
    internal enum prism {
        internal static let loadAllStories = Prism<DiscoverTab.Action, ()>(
            tryGet: { if case .loadAllStories = $0 { return () } else { return nil } },
            inject: { .loadAllStories })

        internal static let setAllStoriesData = Prism<DiscoverTab.Action,Loadable<[Story], HashableWrapper<AppError>>>(
            tryGet: { if case .setAllStoriesData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setAllStoriesData(value:x1) })

        internal static let loadData = Prism<DiscoverTab.Action, ()>(
            tryGet: { if case .loadData = $0 { return () } else { return nil } },
            inject: { .loadData })

        internal static let loadAuthorStories = Prism<DiscoverTab.Action,Author>(
            tryGet: { if case .loadAuthorStories(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .loadAuthorStories(value:x1) })

        internal static let setAuthorStoriesData = Prism<DiscoverTab.Action,(Author, Loadable<[Story], HashableWrapper<AppError>>)>(
            tryGet: { if case .setAuthorStoriesData(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2) in .setAuthorStoriesData(value:x1, content:x2) })

        internal static let setDiscoverData = Prism<DiscoverTab.Action,DiscoverData>(
            tryGet: { if case .setDiscoverData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setDiscoverData(value:x1) })

        internal static let setError = Prism<DiscoverTab.Action,AppError>(
            tryGet: { if case .setError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setError(value:x1) })

        internal static let loadSeriesStories = Prism<DiscoverTab.Action,Series>(
            tryGet: { if case .loadSeriesStories(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .loadSeriesStories(value:x1) })

        internal static let setSeriesStoriesData = Prism<DiscoverTab.Action,(Series, Loadable<[Story], HashableWrapper<AppError>>)>(
            tryGet: { if case .setSeriesStoriesData(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2) in .setSeriesStoriesData(series:x1, content:x2) })

        internal static let loadCategoryStories = Prism<DiscoverTab.Action,Category>(
            tryGet: { if case .loadCategoryStories(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .loadCategoryStories(value:x1) })

        internal static let setCategoryStoriesData = Prism<DiscoverTab.Action,(Category, Loadable<[Story], HashableWrapper<AppError>>)>(
            tryGet: { if case .setCategoryStoriesData(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2) in .setCategoryStoriesData(category:x1, content:x2) })

    }
}



extension MainModule.Action {
    internal enum prism {
        internal static let setTabIndex = Prism<MainModule.Action,Int>(
            tryGet: { if case .setTabIndex(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setTabIndex(value:x1) })

        internal static let discoverAction = Prism<MainModule.Action,DiscoverTab.Action>(
            tryGet: { if case .discoverAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .discoverAction(value:x1) })

        internal static let sleepAction = Prism<MainModule.Action,SleepTab.Action>(
            tryGet: { if case .sleepAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .sleepAction(value:x1) })

        internal static let favoritesAction = Prism<MainModule.Action,FavoritesTab.Action>(
            tryGet: { if case .favoritesAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .favoritesAction(value:x1) })

    }
}



extension Player.Action {
    internal enum prism {
        internal static let playTap = Prism<Player.Action, ()>(
            tryGet: { if case .playTap = $0 { return () } else { return nil } },
            inject: { .playTap })

        internal static let favoriteTap = Prism<Player.Action, ()>(
            tryGet: { if case .favoriteTap = $0 { return () } else { return nil } },
            inject: { .favoriteTap })

        internal static let initializePlayerWithItem = Prism<Player.Action, ()>(
            tryGet: { if case .initializePlayerWithItem = $0 { return () } else { return nil } },
            inject: { .initializePlayerWithItem })

        internal static let setIsPlaying = Prism<Player.Action,Bool>(
            tryGet: { if case .setIsPlaying(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setIsPlaying(value:x1) })

        internal static let seekToProgress = Prism<Player.Action,Double>(
            tryGet: { if case .seekToProgress(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .seekToProgress(value:x1) })

        internal static let setPlaybackProgress = Prism<Player.Action,Double>(
            tryGet: { if case .setPlaybackProgress(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setPlaybackProgress(value:x1) })

        internal static let fwdSeek = Prism<Player.Action, ()>(
            tryGet: { if case .fwdSeek = $0 { return () } else { return nil } },
            inject: { .fwdSeek })

        internal static let bcwdSeek = Prism<Player.Action, ()>(
            tryGet: { if case .bcwdSeek = $0 { return () } else { return nil } },
            inject: { .bcwdSeek })

        internal static let forcePausePlayback = Prism<Player.Action, ()>(
            tryGet: { if case .forcePausePlayback = $0 { return () } else { return nil } },
            inject: { .forcePausePlayback })

    }
}



extension Settings.Action {
    internal enum prism {
        internal static let setSubscriptionActive = Prism<Settings.Action,Bool>(
            tryGet: { if case .setSubscriptionActive(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSubscriptionActive(value:x1) })

        internal static let setNotificationsActive = Prism<Settings.Action,Bool>(
            tryGet: { if case .setNotificationsActive(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setNotificationsActive(value:x1) })

        internal static let openAppSettings = Prism<Settings.Action, ()>(
            tryGet: { if case .openAppSettings = $0 { return () } else { return nil } },
            inject: { .openAppSettings })

        internal static let restorePurchase = Prism<Settings.Action, ()>(
            tryGet: { if case .restorePurchase = $0 { return () } else { return nil } },
            inject: { .restorePurchase })

        internal static let setIsLoading = Prism<Settings.Action,Bool>(
            tryGet: { if case .setIsLoading(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setIsLoading(value:x1) })

        internal static let setError = Prism<Settings.Action,Settings.Error>(
            tryGet: { if case .setError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setError(value:x1) })

    }
}



extension SleepTab.Action {
    internal enum prism {
        internal static let loadData = Prism<SleepTab.Action, ()>(
            tryGet: { if case .loadData = $0 { return () } else { return nil } },
            inject: { .loadData })

        internal static let loadSleepStories = Prism<SleepTab.Action, ()>(
            tryGet: { if case .loadSleepStories = $0 { return () } else { return nil } },
            inject: { .loadSleepStories })

        internal static let setSleepStories = Prism<SleepTab.Action,[Story]>(
            tryGet: { if case .setSleepStories(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepStories(value:x1) })

        internal static let setSleepStoriesError = Prism<SleepTab.Action,AppError>(
            tryGet: { if case .setSleepStoriesError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepStoriesError(value:x1) })

        internal static let setSleepData = Prism<SleepTab.Action,SleepData>(
            tryGet: { if case .setSleepData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepData(value:x1) })

        internal static let setSleepDataError = Prism<SleepTab.Action,AppError>(
            tryGet: { if case .setSleepDataError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepDataError(value:x1) })

        internal static let loadStoriesForCategory = Prism<SleepTab.Action,Category>(
            tryGet: { if case .loadStoriesForCategory(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .loadStoriesForCategory(value:x1) })

        internal static let setStoriesForCategory = Prism<SleepTab.Action,(Category, Loadable<[Story], HashableWrapper<AppError>>)>(
            tryGet: { if case .setStoriesForCategory(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2) in .setStoriesForCategory(value:x1, content:x2) })

    }
}


