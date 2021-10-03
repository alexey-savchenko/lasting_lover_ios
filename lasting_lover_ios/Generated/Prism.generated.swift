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


