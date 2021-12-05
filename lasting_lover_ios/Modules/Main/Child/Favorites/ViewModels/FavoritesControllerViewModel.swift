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
	
	let viewModelsSubject = ReplaySubject<[StoryCellViewModel]>.createUnbounded()
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<FavoritesTab.State>,
		dispatch: @escaping DispatchFunction<FavoritesTab.Action>
	) {
		
		state
			.map { state in
				return state.items
					.map(StoryCellViewModel.init)
			}
			.subscribe(viewModelsSubject)
			.disposed(by: disposeBag)
		
		self.input = Input(
			selectedStoryAtIndex: selectedStoryAtIndexSubject.asObserver()
		)
		self.output = Output(
			seleсtedStory: selectedStoryAtIndexSubject.flatMap({ index in
				return state.take(1).map { state in
					return state.items[index.item]
				}
			}),
			contents: viewModelsSubject
				.map(Section.init)
				.map(toArray)
		)
	
		viewModelsSubject
			.flatMap { vms in return Observable.merge(vms.map { $0.output.deleteItem }) }
			.bind { story in
				dispatch(.removeItem(item: story))
			}
			.disposed(by: disposeBag)
	}
}
