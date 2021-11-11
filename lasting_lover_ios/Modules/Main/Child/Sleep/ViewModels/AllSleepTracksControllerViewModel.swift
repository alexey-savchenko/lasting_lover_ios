//
//  AllSleepTracksControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 10.11.2021.
//

import Foundation
import RxSwift
import UNILibCore
import RxUNILib

class AllSleepTracksControllerViewModel {
	struct Input {
		let selectedItem: AnyObserver<Int>
		let backTap: AnyObserver<Void>
	}
	
	let selectedItemSubject = PublishSubject<Int>()
	let backTapSubject = PublishSubject<Void>()
	
	struct Output {
		let contents: Observable<Loadable<[Section<StoryCellViewModel>], HashableWrapper<SleepTab.Error>>>
		let selectedStory: Observable<Story>
		let backTap: Observable<Void>
	}
	
	let selectedStorySubject = PublishSubject<Story>()
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<SleepTab.State>,
		dispatch: @escaping DispatchFunction<SleepTab.Action>
	) {
		self.input = Input(
			selectedItem: selectedItemSubject.asObserver(),
			backTap: backTapSubject.asObserver()
		)
		self.output = Output(
			contents: state
				.map { $0.sleepStories }
				.map { l in l
				.map { array -> [StoryCellViewModel] in
					return array.map(StoryCellViewModel.init)
				}
				.map(Section.init(items:))
				.map(toArray)
				},
			selectedStory: selectedStorySubject.asObservable(),
			backTap: backTapSubject.asObservable()
		)
		
		dispatch(.loadSleepStories)
		
		selectedItemSubject
			.withLatestFrom(state) { ($0, $1) }
			.map { index, state in
				return state.sleepStories.map { $0[index] }
			}
			.compactMap { value -> Story? in
				if case .item(let item) = value {
					return item
				} else {
					return nil
				}
			}
			.subscribe(selectedStorySubject)
			.disposed(by: disposeBag)
	}
	
	deinit {
		print("\(self) deinit")
	}
}
