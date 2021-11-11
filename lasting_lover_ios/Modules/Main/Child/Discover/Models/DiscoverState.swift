//
//  DiscoverState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import RxSwift

enum DiscoverTab {
	
	enum Error: LocalizedError, Hashable {
		case networkError
		
		var errorDescription: String? {
			switch self {
			case .networkError:
				return L10n.errorNetworkUnreachable
			}
		}
	}
	
	/// sourcery: lens
	struct State: Hashable {
		let data: Loadable<DiscoverData, HashableWrapper<DiscoverTab.Error>>
	}
	
	/// sourcery: prism
	enum Action {
		case loadData
		case setDiscoverData(value: DiscoverData)
		case setError(value: DiscoverTab.Error)
	}
	
	static let middleware: Middleware<DiscoverTab.State, DiscoverTab.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setDiscoverData,
						.setError:
					next(action)
				case .loadData:
					
					var disposable: Disposable?
					
					disposable = Current
						.backend()
						.getDiscoverData()
						.subscribe(
							onNext: { data in
								
								dispatch(.setDiscoverData(value: data))
								disposable?.dispose()
							},
							onError: { error in
								dispatch(.setError(value: .networkError))
								disposable?.dispose()
							}
						)
				}
			}
		}
	}
	
	static let reducer = Reducer<DiscoverTab.State, DiscoverTab.Action> { state, action in
		switch action {
		case .loadData:
			return state
		case .setDiscoverData(let value):
			return DiscoverTab.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<DiscoverTab.Error>>.item(item: value))(state)
		case .setError(let value):
			return DiscoverTab.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<DiscoverTab.Error>>.error(error: HashableWrapper(value: value)))(state)
		}
	}
}