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

enum Discover {
	
	enum Error: LocalizedError, Hashable {
		case networkError
		
		var localizedDescription: String? {
			switch self {
			case .networkError:
				return L10n.errorNetworkUnreachable
			}
		}
	}
	
	/// sourcery: lens
	struct State: Hashable {
		let data: Loadable<DiscoverData, HashableWrapper<Discover.Error>>
	}
	
	/// sourcery: prism
	enum Action {
		case loadData
		case setDiscoverData(value: DiscoverData)
		case setError(value: Discover.Error)
	}
	
	static let middleware: Middleware<Discover.State, Discover.Action> = { dispatch, getState in
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
	
	static let reducer = Reducer<Discover.State, Discover.Action> { state, action in
		switch action {
		case .loadData:
			return state
		case .setDiscoverData(let value):
			return Discover.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<Discover.Error>>.item(item: value))(state)
		case .setError(let value):
			return Discover.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<Discover.Error>>.error(error: HashableWrapper(value: value)))(state)
		}
	}
}
