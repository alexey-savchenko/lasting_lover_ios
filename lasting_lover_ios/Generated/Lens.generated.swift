// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import UNILibCore
import RxUNILib

extension AppState {
  enum lens {
    static let profileState = Lens<AppState, SettingsState>(
      get: { $0.profileState },
      set: { part in 
        { whole in
          AppState.init(profileState: part, loginState: whole.loginState, logoutTrigger: whole.logoutTrigger)
        }
      }
    )
    static let loginState = Lens<AppState, LoginState>(
      get: { $0.loginState },
      set: { part in 
        { whole in
          AppState.init(profileState: whole.profileState, loginState: part, logoutTrigger: whole.logoutTrigger)
        }
      }
    )
    static let logoutTrigger = Lens<AppState, Trigger>(
      get: { $0.logoutTrigger },
      set: { part in 
        { whole in
          AppState.init(profileState: whole.profileState, loginState: whole.loginState, logoutTrigger: part)
        }
      }
    )
  }
}
extension LoginState {
  enum lens {
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
