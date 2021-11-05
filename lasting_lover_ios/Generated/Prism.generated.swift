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



extension Discover.Action {
    internal enum prism {
        internal static let loadData = Prism<Discover.Action, ()>(
            tryGet: { if case .loadData = $0 { return () } else { return nil } },
            inject: { .loadData })

        internal static let setDiscoverData = Prism<Discover.Action,DiscoverData>(
            tryGet: { if case .setDiscoverData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setDiscoverData(value:x1) })

        internal static let setError = Prism<Discover.Action,Discover.Error>(
            tryGet: { if case .setError(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setError(value:x1) })

    }
}



extension MainModule.Action {
    internal enum prism {
        internal static let setTabIndex = Prism<MainModule.Action,Int>(
            tryGet: { if case .setTabIndex(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setTabIndex(value:x1) })

        internal static let discoverAction = Prism<MainModule.Action,Discover.Action>(
            tryGet: { if case .discoverAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .discoverAction(value:x1) })

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

    }
}



extension Settings.Action {
    internal enum prism {
        internal static let setSubscriptionActive = Prism<Settings.Action,Bool>(
            tryGet: { if case .setSubscriptionActive(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .setSubscriptionActive(value:x1) })

    }
}


