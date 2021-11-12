//
//  SleepControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 04.10.2021.
//

import Foundation
import RxSwift
import UNILibCore
import RxUNILib

class SleepControllerViewModel {
	struct Input {
		let selectedCategoryAtIndex: AnyObserver<IndexPath>
		let selectedFeaturedStoryAtIndex: AnyObserver<IndexPath>
	}
	
	private let selectedCategoryAtIndexSubject = PublishSubject<IndexPath>()
	private let selectedFeaturedStoryAtIndexSubject = PublishSubject<IndexPath>()
	
	struct Output {
		let data: Observable<Loadable<SleepData, HashableWrapper<AppError>>>
		let selectedCategory: Observable<Category>
		let selectedFeatuedStory: Observable<Story>
	}
	
	let input: Input
	let output: Output
	
	init(
		state: Observable<SleepTab.State>,
		dispatch: @escaping DispatchFunction<SleepTab.Action>
	) {
		self.input = Input(
			selectedCategoryAtIndex: selectedCategoryAtIndexSubject.asObserver(),
			selectedFeaturedStoryAtIndex: selectedFeaturedStoryAtIndexSubject.asObserver()
		)
		self.output = Output(
			data: state.map { $0.data }.distinctUntilChanged(),
			selectedCategory: selectedCategoryAtIndexSubject
				.flatMap { indexPath -> Observable<Category> in
					return state.take(1).compactMap { s -> Category? in
						if case .item(let value) = s.data {
							return value.categories[safe: indexPath.item]
						} else {
							return nil
						}
					}
				},
			selectedFeatuedStory: selectedFeaturedStoryAtIndexSubject
				.flatMap { indexPath -> Observable<Story> in
					return state.take(1).compactMap { s -> Story? in
						if case .item(let value) = s.data {
							return value.featuredStories[safe: indexPath.item]
						} else {
							return nil
						}
					}
				}
		)
		
		dispatch(.loadData)
	}
}
