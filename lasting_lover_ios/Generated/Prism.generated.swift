// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import UNILibCore
import RxUNILib




extension AppAction {
    internal enum prism {
        internal static let mainModuleAction = Prism<AppAction,MainModuleAction>(
            tryGet: { if case .mainModuleAction(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .mainModuleAction(action:x1) })

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

    }
}


