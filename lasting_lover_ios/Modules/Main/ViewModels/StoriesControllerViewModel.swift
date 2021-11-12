//
//  StoriesControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 10.11.2021.
//

import Foundation
import RxSwift
import UNILibCore
import RxUNILib

enum StoryRequestTarget {
	case allSleepStories
	case sleepStoriesForCategory(value: Category)
	case discoverStoriesForAutor(author: Author)
}

class StoriesControllerViewModel {
	struct Input {
		let selectedItem: AnyObserver<Int>
		let backTap: AnyObserver<Void>
	}
	
	let selectedItemSubject = PublishSubject<Int>()
	let backTapSubject = PublishSubject<Void>()
	
	struct Output {
		let contents: Observable<Loadable<[Section<StoryCellViewModel>], HashableWrapper<AppError>>>
		let selectedStory: Observable<Story>
		let backTap: Observable<Void>
		let title: String
	}
	
	let selectedStorySubject = PublishSubject<Story>()
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		target: StoryRequestTarget,
		state: Observable<App.State>,
		dispatch: @escaping DispatchFunction<App.Action>
	) {
		
		switch target {
		case .discoverStoriesForAutor(let author):
			dispatch(.mainModuleAction(action: .discoverAction(value: .loadAuthorStories(value: author))))
		case .allSleepStories:
			dispatch(.mainModuleAction(action: .sleepAction(value: .loadSleepStories)))
		case .sleepStoriesForCategory(let value):
			dispatch(.mainModuleAction(action: .sleepAction(value: .loadStoriesForCategory(value: value))))
		}
		
		self.input = Input(
			selectedItem: selectedItemSubject.asObserver(),
			backTap: backTapSubject.asObserver()
		)
		self.output = Output(
			contents: state
				.map { s -> Loadable<[Story], HashableWrapper<AppError>> in
					switch target {
					case .discoverStoriesForAutor(let author):
						return s.mainModuleState.discoverState.authorStories[author] ?? .indefiniteLoading
					case .allSleepStories:
						return s.mainModuleState.sleepState.sleepStories
					case .sleepStoriesForCategory(let value):
						return s.mainModuleState.sleepState.categoryStories[value] ?? .indefiniteLoading
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
				case .allSleepStories:
					return L10n.allTracks
				case .sleepStoriesForCategory(let value):
					return value.name
				case .discoverStoriesForAutor(let author):
					return author.name
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
