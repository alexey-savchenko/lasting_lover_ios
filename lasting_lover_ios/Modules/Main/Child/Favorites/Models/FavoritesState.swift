//
//  FavoritesState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import Foundation
import UNILibCore
import RxUNILib

enum Favorites {
	
	/// sourcery: lens
	struct State: Hashable {
		let items: [Story]
	}
	
	enum Action {
		case itemTap(item: Story)
		case addItem(item: Story)
		case removeItem(item: Story)
	}
	
	static let middleware: Middleware<Favorites.State, Favorites.Action> = { dispatch, getState in
		return { next in
			return { action in
				switch action {
				
				case .addItem: next(action)
				case .itemTap(let item):
					guard let state = getState() else { return }
					if state.items.contains(where: { $0.id == item.id }) {
						dispatch(.removeItem(item: item))
					} else {
						dispatch(.addItem(item: item))
					}
				case .removeItem: next(action)
				}
			}
		}
	}
	
	static let reducer: Reducer<Favorites.State, Favorites.Action> = .init { state, action in
		switch action {
		case .itemTap:
			return state
		case .addItem(item: let item):
			var updatedItems: [Story] {
				return state.items + [item]
			}
			return Favorites.State.lens.items.set(updatedItems)(state)
		case .removeItem(item: let item):
			var updatedItems: [Story] {
				return state.items.filter { $0.id != item.id }
			}
			return Favorites.State.lens.items.set(updatedItems)(state)
		}
	}
}
