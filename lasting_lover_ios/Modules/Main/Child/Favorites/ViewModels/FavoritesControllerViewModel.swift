//
//  FavoritesControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import RxUNILib
import RxSwift
import UNILibCore

class FavoritesControllerViewModel {
	struct Input {
		let selectedStoryAtIndex: AnyObserver<IndexPath>
	}
	
	private let selectedStoryAtIndexSubject = PublishSubject<IndexPath>()
	
	struct Output {
		let seleсtedStory: Observable<Story>
		let contents: Observable<[Section<StoryCellViewModel>]>
	}
	
	let input: Input
	let output: Output
	
	init(
		state: Observable<FavoritesTab.State>,
		dispatch: @escaping DispatchFunction<FavoritesTab.Action>
	) {
		self.input = Input(
			selectedStoryAtIndex: selectedStoryAtIndexSubject.asObserver()
		)
		self.output = Output(
			seleсtedStory: selectedStoryAtIndexSubject.flatMap({ index in
				return state.take(1).map { state in
					return state.items[index.item]
				}
			}),
			contents: state.map { state in
				return state.items
					.map(StoryCellViewModel.init)
			}
				.map(Section.init)
				.map(toArray)
		)
	}
}
