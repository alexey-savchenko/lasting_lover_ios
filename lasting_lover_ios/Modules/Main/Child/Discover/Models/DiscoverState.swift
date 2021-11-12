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
	
	/// sourcery: lens
	struct State: Hashable {
		let data: Loadable<DiscoverData, HashableWrapper<AppError>>
		let authorStories: [Author: Loadable<[Story], HashableWrapper<AppError>>]
	}
	
	/// sourcery: prism
	enum Action {
		case loadData
		case loadAuthorStories(value: Author)
		case setAuthorStoriesData(value: Author, content: Loadable<[Story], HashableWrapper<AppError>>)
		case setDiscoverData(value: DiscoverData)
		case setError(value: AppError)
	}
	
	static let middleware: Middleware<DiscoverTab.State, DiscoverTab.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setDiscoverData,
						.setError,
						.setAuthorStoriesData:
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
				case .loadAuthorStories(let value):
					var disposable: Disposable?
					
					disposable = Current
						.backend()
						.getStoriesFor(value)
						.subscribe(
							onNext: { data in
								dispatch(.setAuthorStoriesData(value: value, content: .item(item: data)))
								disposable?.dispose()
							},
							onError: { error in
								dispatch(
									.setAuthorStoriesData(
										value: value,
										content: .error(
											error: HashableWrapper<AppError>(value: .networkError)
										)
									)
								)
								disposable?.dispose()
							}
						)
				}
			}
		}
	}
	
	static let reducer = Reducer<DiscoverTab.State, DiscoverTab.Action> { state, action in
		switch action {
		case .loadData, .loadAuthorStories:
			return state
		case .setAuthorStoriesData(let author, let content):
			var subState = state.authorStories
			subState[author] = content
			return DiscoverTab.State.lens.authorStories.set(subState)(state)
		case .setDiscoverData(let value):
			return DiscoverTab.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<AppError>>.item(item: value))(state)
		case .setError(let value):
			return DiscoverTab.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<AppError>>.error(error: HashableWrapper(value: value)))(state)
		}
	}
}
