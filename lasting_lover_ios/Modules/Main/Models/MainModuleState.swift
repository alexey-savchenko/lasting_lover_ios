//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import Foundation
import UNILibCore

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

	private static let _reducer = Reducer<MainModule.State, MainModule.Action> { state, action in
		switch action {
		case .setTabIndex(let value):
			return MainModule.State.lens.selectedTabIndex.set(value)(state)
		}
	}

	static let reducer: Reducer<MainModule.State, MainModule.Action> = _reducer <>
	Discover.reducer
		.lift(localStateLens: MainModule.State.lens.discoverState, localActionPrism: MainModule.Action.prism.discoverAction)
}

