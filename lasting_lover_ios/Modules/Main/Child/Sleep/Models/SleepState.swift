//
//  SleepState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import RxSwift

enum SleepTab {
	
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
		let data: Loadable<SleepData, HashableWrapper<SleepTab.Error>>
	}
	/// sourcery: prism
	enum Action {
		case loadData
		case setSleepData(value: SleepData)
		case setError(value: SleepTab.Error)
	}
	
	static let reducer = Reducer<SleepTab.State, SleepTab.Action> { state, action in
		switch action {
		case .loadData:
			return state
		case .setSleepData(let value):
			return SleepTab.State.lens.data.set(Loadable<SleepData, HashableWrapper<SleepTab.Error>>.item(item: value))(state)
		case .setError(let value):
			return SleepTab.State.lens.data.set(Loadable<SleepData, HashableWrapper<SleepTab.Error>>.error(error: HashableWrapper(value: value)))(state)
		}
	}
	
	static let middleware: Middleware<SleepTab.State, SleepTab.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setSleepData,
						.setError:
					next(action)
				case .loadData:
					
					var disposable: Disposable?
					
					disposable = Current
						.backend()
						.getSleepData()
						.subscribe(
							onNext: { data in
								
								dispatch(.setSleepData(value: data))
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
}
