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
