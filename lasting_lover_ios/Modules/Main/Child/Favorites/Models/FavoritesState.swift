//
//  FavoritesState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import Foundation
import UNILibCore
import RxUNILib

enum FavoritesTab {
	
	/// sourcery: lens
	struct State: Hashable {
		let items: [Story]
	}
	
	enum Action {
		case itemTap(item: Story)
		case addItem(item: Story)
		case removeItem(item: Story)
	}
	
	static let middleware: Middleware<FavoritesTab.State, FavoritesTab.Action> = { dispatch, getState in
		return { next in
			return { action in
				switch action {
				
				case .addItem(let item):
					Current.favoritesService().addFavorite(item)
					next(action)
				case .itemTap(let item):
					guard let state = getState() else { return }
					if state.items.contains(where: { $0.id == item.id }) {
						dispatch(.removeItem(item: item))
					} else {
						dispatch(.addItem(item: item))
					}
				case .removeItem(let item):
					Current.favoritesService().removeFavorite(item)
					next(action)
				}
			}
		}
	}
	
	static let reducer: Reducer<FavoritesTab.State, FavoritesTab.Action> = .init { state, action in
		switch action {
		case .itemTap:
			return state
		case .addItem(item: let item):
			var updatedItems: [Story] {
				return state.items + [item]
			}
			return FavoritesTab.State.lens.items.set(updatedItems)(state)
		case .removeItem(item: let item):
			var updatedItems: [Story] {
				return state.items.filter { $0.id != item.id }
			}
			return FavoritesTab.State.lens.items.set(updatedItems)(state)
		}
	}
}
