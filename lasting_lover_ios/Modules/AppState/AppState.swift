//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.09.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import UserNotifications

typealias Trigger = IdentifiedBox<_Void>?

enum App {
	/// sourcery: lens
	struct State: Hashable {
		let settingsState: Settings.State
		let mainModuleState: MainModule.State

		static func `default`() -> App.State {
			return App.State(
				settingsState: Settings.State.default(),
				mainModuleState: MainModule.State(
					selectedTabIndex: 0,
					discoverState: DiscoverTab.State(
						data: .indefiniteLoading,
						authorStories: [:],
						seriesStories: [:],
						categoryStories: [:],
						allStories: .indefiniteLoading
					),
					sleepState: SleepTab.State(
						data: .indefiniteLoading,
						sleepStories: .indefiniteLoading,
						categoryStories: [:]
					),
					favoritesState: FavoritesTab.State(
						items: Current.favoritesService().favoriteItems()
					)
				)
			)
		}
	}

	/// sourcery: prism
	enum Action {
		case mainModuleAction(action: MainModule.Action)
		case settingsAction(action: Settings.Action)
		case requestNotificationAccess
		case refreshNotificationAccess
	}

	static let reducer = MainModule.reducer
		.lift(
			localStateLens: App.State.lens.mainModuleState,
			localActionPrism: App.Action.prism.mainModuleAction
		)
	<>
	Settings.reducer
		.lift(
			localStateLens: App.State.lens.settingsState,
			localActionPrism: App.Action.prism.settingsAction
		)

	static let middleware: Middleware<App.State, App.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .refreshNotificationAccess:
					UNUserNotificationCenter.current().getNotificationSettings { settings in
						let granted = settings.authorizationStatus == .authorized
						dispatch(.settingsAction(action: .setNotificationsActive(value: granted)))
					}
				case .requestNotificationAccess:
					UNUserNotificationCenter.current().requestAuthorization(
						options: [.alert, .badge]) { granted, error in
							dispatch(.settingsAction(action: .setNotificationsActive(value: granted)))
						}
				case .mainModuleAction(let action):
					MainModule
						.middleware(
							App.Action.mainModuleAction <*> dispatch, { getState().map { $0.mainModuleState } }
						)(
							App.Action.mainModuleAction <*> next
						)(action)
				case .settingsAction(let action):
					Settings
						.middleware(
							App.Action.settingsAction <*> dispatch, { getState().map { $0.settingsState } }
						)(
							App.Action.settingsAction <*> next
						)(action)
				}
//				next(action)
			}
		}
	}

}
