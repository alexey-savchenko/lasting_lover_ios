//
//  SettingsState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import UIKit
import RxSwift

enum Settings {
	
	enum Error: LocalizedError {
		case noPurchasesToRestore
		
		var errorDescription: String? {
			switch self {
			case .noPurchasesToRestore:
				return L10n.noPurchasesToRestore
			}
		}
	}
	/// sourcery: lens
	struct State: Hashable {
		let subscriptionActive: Bool
		let items: [SettingsItem]
		let notificationsEnabled: Bool
		let isLoading: Bool
		let errors: HashableWrapper<Settings.Error>?
		
		static func `default`() -> Settings.State {
			return .init(
				subscriptionActive: Current.subscriptionService().subscriptionActive,
				items: SettingsItem.allCases,
				notificationsEnabled: false,
				isLoading: false,
				errors: nil
			)
		}
	}
	
	/// sourcery: prism
	enum Action {
		case setSubscriptionActive(value: Bool)
		case setNotificationsActive(value: Bool)
		case openAppSettings
		case restorePurchase
		case setIsLoading(value: Bool)
		case setError(value: Settings.Error)
	}
	
	static let reducer = Reducer<Settings.State, Settings.Action> { state, action in
		switch action {
		case .openAppSettings, .restorePurchase:
			return state
		case .setError(let value):
			return Settings.State.lens.errors.set(.init(value: value))(state)
		case .setIsLoading(let value):
			return Settings.State.lens.isLoading.set(value)(state)
		case .setNotificationsActive(let value):
			return Settings.State.lens.notificationsEnabled.set(value)(state)
		case .setSubscriptionActive(let value):
			return Settings.State.lens.subscriptionActive.set(value)(state)
		}
	}
	
	static let middleware: Middleware<Settings.State, Settings.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .restorePurchase:
					dispatch(.setIsLoading(value: true))
					var d: Disposable?
					d = Current.purchaseService()
						.restore()
						.subscribe(onNext: { value in
							dispatch(.setIsLoading(value: false))
							if let value = value {
								Current.subscriptionService().setSubscriptionActive(value)
								appStore.dispatch(.settingsAction(action: .setSubscriptionActive(value: true)))
								dispatch(.setSubscriptionActive(value: true))
							} else {
								dispatch(.setError(value: .noPurchasesToRestore))
							}
							
							d?.dispose()
						})
				case .openAppSettings:
					UIApplication.shared.open(
						URL(string: UIApplication.openSettingsURLString)!,
						options: [:]
					)
				case .setSubscriptionActive,
						.setNotificationsActive,
						.setIsLoading,
						.setError:
					next(action)
				}
			}
		}
	}
}
