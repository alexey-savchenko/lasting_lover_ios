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
		let discoverState: Discover.State
	}
	
	/// sourcery: prism
	enum Action {
		case setTabIndex(value: Int)
		case discoverAction(value: Discover.Action)
	}

	static let reducer = Reducer<MainModule.State, MainModule.Action> { state, action in
		switch action {
		case .setTabIndex(let value):
			return MainModule.State.lens.selectedTabIndex.set(value)(state)
		case .discoverAction(let value):
			return State.lens.discoverState.set(Discover.reducer.reduce(state.discoverState, value))(state)
		}
	}
	
	static let middleware: Middleware<MainModule.State, MainModule.Action> = { dispatch, getState in
		return { next in
			return { action in
				switch action {
				case .setTabIndex:
					next(action)
				case .discoverAction(let value):
					Discover
						.middleware(
							MainModule.Action.prism.discoverAction.inject <*> dispatch, { getState().map { $0.discoverState } }
						)(
							MainModule.Action.prism.discoverAction.inject <*> next
						)(value)
				}
			}
		}
	}
}

