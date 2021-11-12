//
//  SleepStoriesControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 10.11.2021.
//

import Foundation
import RxSwift
import UNILibCore
import RxUNILib

enum SleepStories {
	case all
	case forCategory(value: Category)
}

class SleepStoriesControllerViewModel {
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
		let title: String
	}
	
	let selectedStorySubject = PublishSubject<Story>()
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		target: SleepStories,
		state: Observable<SleepTab.State>,
		dispatch: @escaping DispatchFunction<SleepTab.Action>
	) {
		
		switch target {
		case .all:
			dispatch(.loadSleepStories)
		case .forCategory(let value):
			dispatch(.loadStoriesForCategory(value: value))
		}
		
		self.input = Input(
			selectedItem: selectedItemSubject.asObserver(),
			backTap: backTapSubject.asObserver()
		)
		self.output = Output(
			contents: state
				.map { s -> Loadable<[Story], HashableWrapper<SleepTab.Error>> in
					switch target {
					case .all:
						return s.sleepStories
					case .forCategory(let value):
						return s.categoryStories[value] ?? .indefiniteLoading
					}
				}
				.map { l in l
				.map { array -> [StoryCellViewModel] in
					return array.map(StoryCellViewModel.init)
				}
				.map(Section.init(items:))
				.map(toArray)
				},
			selectedStory: selectedStorySubject.asObservable(),
			backTap: backTapSubject.asObservable(),
			title: {
				switch target {
				case .all:
					return L10n.allTracks
				case .forCategory(let value):
					return value.name
				}
			}()
		)

		selectedItemSubject
			.withLatestFrom(output.contents) { ($0, $1) }
			.map { index, content in
				return content.map { sections in return sections[0].items[index].story }
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
