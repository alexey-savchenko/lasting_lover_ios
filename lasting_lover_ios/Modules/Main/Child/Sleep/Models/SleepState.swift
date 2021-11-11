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
		let sleepStories: Loadable<[Story], HashableWrapper<SleepTab.Error>>
	}
	/// sourcery: prism
	enum Action {
		case loadData
		case loadSleepStories
		case setSleepStories(value: [Story])
		case setSleepStoriesError(value: SleepTab.Error)
		case setSleepData(value: SleepData)
		case setSleepDataError(value: SleepTab.Error)
	}
	
	static let reducer = Reducer<SleepTab.State, SleepTab.Action> { state, action in
		switch action {
		case .loadData, .loadSleepStories:
			return state
		case .setSleepData(let value):
			return SleepTab.State.lens.data.set(.item(item: value))(state)
		case .setSleepDataError(let value):
			return SleepTab.State.lens.data.set(.error(error: HashableWrapper(value: value)))(state)
		case .setSleepStories(value: let value):
			return SleepTab.State.lens.sleepStories.set(.item(item: value))(state)
		case .setSleepStoriesError(value: let value):
			return SleepTab.State.lens.sleepStories.set(.error(error: HashableWrapper(value: value)))(state)
		}
	}
	
	static let middleware: Middleware<SleepTab.State, SleepTab.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setSleepData,
						.setSleepDataError,
						.setSleepStories,
						.setSleepStoriesError:
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
								dispatch(.setSleepDataError(value: .networkError))
								disposable?.dispose()
							}
						)
				case .loadSleepStories:
					var disposable: Disposable?
					
					disposable = Current
						.backend()
						.getAllSleepStories()
						.subscribe(
							onNext: { data in
								
								dispatch(.setSleepStories(value: data))
								disposable?.dispose()
							},
							onError: { error in
								dispatch(.setSleepStoriesError(value: .networkError))
								disposable?.dispose()
							}
						)
				}
			}
		}
	}
}