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
		let seriesStories: [Series: Loadable<[Story], HashableWrapper<AppError>>]
		let categoryStories: [Category: Loadable<[Story], HashableWrapper<AppError>>]
		let allStories: Loadable<[Story], HashableWrapper<AppError>>
	}
	
	/// sourcery: prism
	enum Action {
		case loadAllStories
		case setAllStoriesData(value: Loadable<[Story], HashableWrapper<AppError>>)
		case loadData
		case loadAuthorStories(value: Author)
		case setAuthorStoriesData(value: Author, content: Loadable<[Story], HashableWrapper<AppError>>)
		case setDiscoverData(value: DiscoverData)
		case setError(value: AppError)
		case loadSeriesStories(value: Series)
		case setSeriesStoriesData(series: Series, content: Loadable<[Story], HashableWrapper<AppError>>)
		case loadCategoryStories(value: Category)
		case setCategoryStoriesData(category: Category, content: Loadable<[Story], HashableWrapper<AppError>>)
	}
	
	static let middleware: Middleware<DiscoverTab.State, DiscoverTab.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .setDiscoverData,
						.setError,
						.setAuthorStoriesData,
						.setSeriesStoriesData,
						.setCategoryStoriesData,
						.setAllStoriesData:
					next(action)
				case .loadAllStories:
					
					guard getState()?.allStories.item == nil else {
						next(action)
						return
					}
					
					var disposable: Disposable?
					
					next(.setAllStoriesData(value: .indefiniteLoading))
					
					disposable = Current.backend()
						.getAllDiscoverStories()
						.subscribe(onNext: { data in
							dispatch(.setAllStoriesData(value: .item(item: data)))
							disposable?.dispose()
						}, onError: { error in
							dispatch(.setAllStoriesData(
								value: .error(error: HashableWrapper<AppError>(value: .networkError)))
							)
							disposable?.dispose()
						})
					
				case .loadCategoryStories(let value):
					guard getState()?.categoryStories[value]?.item == nil else {
						next(action)
						return
					}
					
					var disposable: Disposable?
					
					next(.setCategoryStoriesData(category: value, content: .indefiniteLoading))
					
					disposable = Current.backend()
						.getStoriesFor(value)
						.subscribe(onNext: { data in
							dispatch(.setCategoryStoriesData(category: value, content: .item(item: data)))
							disposable?.dispose()
						}, onError: { error in
							dispatch(.setCategoryStoriesData(
								category: value,
								content: .error(error: HashableWrapper<AppError>(value: .networkError)))
							)
							disposable?.dispose()
						})

				case .loadSeriesStories(let value):
					
					guard getState()?.seriesStories[value]?.item == nil else {
						next(action)
						return
					}
					
					var disposable: Disposable?
					
					next(.setSeriesStoriesData(series: value, content: .indefiniteLoading))
					
					disposable = Current.backend()
						.getStoriesFor(value)
						.subscribe(onNext: { data in
							dispatch(.setSeriesStoriesData(series: value, content: .item(item: data)))
							disposable?.dispose()
						}, onError: { error in
							dispatch(.setSeriesStoriesData(
								series: value,
								content: .error(error: HashableWrapper<AppError>(value: .networkError)))
							)
							disposable?.dispose()
						})
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
					
					guard getState()?.authorStories[value]?.item == nil else {
						next(action)
						return
					}
					
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
		case .loadData,
				.loadAuthorStories,
				.loadSeriesStories,
				.loadCategoryStories,
				.loadAllStories:
			return state
		case .setAllStoriesData(let value):
			return DiscoverTab.State.lens.allStories.set(value)(state)
		case .setCategoryStoriesData(let category, let content):
			var subState = state.categoryStories
			subState[category] = content
			return DiscoverTab.State.lens.categoryStories.set(subState)(state)
		case .setAuthorStoriesData(let author, let content):
			var subState = state.authorStories
			subState[author] = content
			return DiscoverTab.State.lens.authorStories.set(subState)(state)
		case .setSeriesStoriesData(let series, let content):
			var subState = state.seriesStories
			subState[series] = content
			return DiscoverTab.State.lens.seriesStories.set(subState)(state)
		case .setDiscoverData(let value):
			return DiscoverTab.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<AppError>>.item(item: value))(state)
		case .setError(let value):
			return DiscoverTab.State.lens.data.set(Loadable<DiscoverData, HashableWrapper<AppError>>.error(error: HashableWrapper(value: value)))(state)
		}
	}
}
