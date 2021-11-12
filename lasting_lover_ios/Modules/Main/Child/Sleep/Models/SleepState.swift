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

enum AppError: LocalizedError, Hashable {
	case networkError
	
	var errorDescription: String? {
		switch self {
		case .networkError:
			return L10n.errorNetworkUnreachable
		}
	}
}

enum SleepTab {
		
	/// sourcery: lens
	struct State: Hashable {
		let data: Loadable<SleepData, HashableWrapper<AppError>>
		let sleepStories: Loadable<[Story], HashableWrapper<AppError>>
		let categoryStories: [Category: Loadable<[Story], HashableWrapper<AppError>>]
	}
	/// sourcery: prism
	enum Action {
		case loadData
		case loadSleepStories
		case setSleepStories(value: [Story])
		case setSleepStoriesError(value: AppError)
		case setSleepData(value: SleepData)
		case setSleepDataError(value: AppError)
		case loadStoriesForCategory(value: Category)
		case setStoriesForCategory(value: Category, content: Loadable<[Story], HashableWrapper<AppError>>)
	}
	
	static let reducer = Reducer<SleepTab.State, SleepTab.Action> { state, action in
		switch action {
		case .loadData, .loadSleepStories, .loadStoriesForCategory:
			return state
		case .setSleepData(let value):
			return SleepTab.State.lens.data.set(.item(item: value))(state)
		case .setSleepDataError(let value):
			return SleepTab.State.lens.data.set(.error(error: HashableWrapper(value: value)))(state)
		case .setSleepStories(value: let value):
			return SleepTab.State.lens.sleepStories.set(.item(item: value))(state)
		case .setSleepStoriesError(value: let value):
			return SleepTab.State.lens.sleepStories.set(.error(error: HashableWrapper(value: value)))(state)
		case .setStoriesForCategory(let value, let content):
			var subState = state.categoryStories
			subState[value] = content
			return SleepTab.State.lens.categoryStories.set(subState)(state)
		}
	}
	
	static let middleware: Middleware<SleepTab.State, SleepTab.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setSleepData,
						.setSleepDataError,
						.setSleepStories,
						.setSleepStoriesError,
						.setStoriesForCategory:
					next(action)
					
				case .loadStoriesForCategory(let value):
					var disposable: Disposable?
					
					dispatch(.setStoriesForCategory(value: value, content: .indefiniteLoading))
					
					disposable = Current
						.backend()
						.getSleepStoriesFor(value)
						.subscribe(
							onNext: { data in
								
								dispatch(.setStoriesForCategory(value: value, content: .item(item: data)))
								disposable?.dispose()
							},
							onError: { error in
								dispatch(
									.setStoriesForCategory(
										value: value,
										content: .error(
											error: HashableWrapper(value: .networkError)
										)
									)
								)
								disposable?.dispose()
							}
						)
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
