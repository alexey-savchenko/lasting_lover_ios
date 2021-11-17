//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib

enum MainModule {
	/// sourcery: lens
	struct State: Hashable {
		let selectedTabIndex: Int
		let discoverState: DiscoverTab.State
		let sleepState: SleepTab.State
		let favoritesState: FavoritesTab.State
	}
	
	/// sourcery: prism
	enum Action {
		case setTabIndex(value: Int)
		case discoverAction(value: DiscoverTab.Action)
		case sleepAction(value: SleepTab.Action)
		case favoritesAction(value: FavoritesTab.Action)
	}

	static let reducer: Reducer<MainModule.State, MainModule.Action> =
	FavoritesTab.reducer.lift(
		localStateLens: MainModule.State.lens.favoritesState,
		localActionPrism: MainModule.Action.prism.favoritesAction
	) <>
	DiscoverTab.reducer.lift(
		localStateLens: MainModule.State.lens.discoverState,
		localActionPrism: MainModule.Action.prism.discoverAction
	) <>
	SleepTab.reducer.lift(
		localStateLens: MainModule.State.lens.sleepState,
		localActionPrism: MainModule.Action.prism.sleepAction
	) <>
	Reducer<MainModule.State, MainModule.Action>(reduce: { state, action in
		if case .setTabIndex(let value) = action {
			return MainModule.State.lens.selectedTabIndex.set(value)(state)
		} else {
			return state
		}
	})
	
	static let middleware: Middleware<MainModule.State, MainModule.Action> = { dispatch, getState in
		return { next in
			return { action in
				switch action {
				case .setTabIndex:
					next(action)
				case .favoritesAction(let value):
					FavoritesTab
						.middleware(
							MainModule.Action.favoritesAction <*> dispatch, { getState().map { $0.favoritesState } }
						)(
							MainModule.Action.favoritesAction <*> next
						)(value)

				case .sleepAction(let value):
					SleepTab
						.middleware(
							MainModule.Action.sleepAction <*> dispatch, { getState().map { $0.sleepState } }
						)(
							MainModule.Action.sleepAction <*> next
						)(value)
				case .discoverAction(let value):
					DiscoverTab
						.middleware(
							MainModule.Action.discoverAction <*> dispatch, { getState().map { $0.discoverState } }
						)(
							MainModule.Action.discoverAction <*> next
						)(value)
				}
			}
		}
	}
}
