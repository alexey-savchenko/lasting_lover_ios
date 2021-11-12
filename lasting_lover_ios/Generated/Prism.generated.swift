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

    }
}



extension DiscoverTab.Action {
    internal enum prism {
        internal static let loadData = Prism<DiscoverTab.Action, ()>(
            tryGet: { if case .loadData = $0 { return () } else { return nil } },
            inject: { .loadData })

        internal static let setDiscoverData = Prism<DiscoverTab.Action,DiscoverData>(
            tryGet: { if case .setDiscoverData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setDiscoverData(value:x1) })

        internal static let setError = Prism<DiscoverTab.Action,DiscoverTab.Error>(
            tryGet: { if case .setError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setError(value:x1) })

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

        internal static let setSleepStoriesError = Prism<SleepTab.Action,SleepTab.Error>(
            tryGet: { if case .setSleepStoriesError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepStoriesError(value:x1) })

        internal static let setSleepData = Prism<SleepTab.Action,SleepData>(
            tryGet: { if case .setSleepData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepData(value:x1) })

        internal static let setSleepDataError = Prism<SleepTab.Action,SleepTab.Error>(
            tryGet: { if case .setSleepDataError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSleepDataError(value:x1) })

    }
}


