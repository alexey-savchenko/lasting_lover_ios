//
//  CategoryControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.11.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UNILibCore
import UIKit

class CategoryControllerViewModel {
	struct Input {
		let selectedStoryAtIndex: AnyObserver<IndexPath>
		let backTap: AnyObserver<Void>
	}
	
	private let backTapSubject = PublishSubject<Void>()
	private let selectedStoryAtIndexSubject = PublishSubject<IndexPath>()
	
	struct Output {
		let backTap: Observable<Void>
		let stories: Observable<Loadable<[Section<StoryCellViewModel>], HashableWrapper<AppError>>>
		let selectedStory: Observable<Story>
		let image: Observable<UIImage>
		let title: String
		let subtitle: String
	}
	
	let input: Input
	let output: Output
	
	init(
		category: Category,
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {

		dispatch(.loadCategoryStories(value: category))
		
		self.input = Input(
			selectedStoryAtIndex: selectedStoryAtIndexSubject.asObserver(),
			backTap: backTapSubject.asObserver()
		)
		self.output = Output(
			backTap: backTapSubject.asObservable(),
			stories: state.compactMap { state in
				state.categoryStories[category].map { l in
					return l.map { array -> [StoryCellViewModel] in
						return array.map(StoryCellViewModel.init)
					}
					.map(Section.init)
					.map(toArray)
			 }
		 },
			selectedStory: selectedStoryAtIndexSubject.flatMap { index in
				return state.take(1).compactMap { state in
					return state.categoryStories[category]?.item.map { $0[index.item] }
				}
			},
			image: Current.imageLoadingService().image(URL(string: category.avatar)!),
			title: category.name,
			subtitle: category.categoryDescription
		)
	}
}
