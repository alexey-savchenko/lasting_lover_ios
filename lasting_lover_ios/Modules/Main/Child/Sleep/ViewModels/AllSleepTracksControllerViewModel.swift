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

enum NoError: LocalizedError, Hashable {
	
}

class AllSleepTracksControllerViewModel {
	struct Input {
		
	}
	
	struct Output {
		let contents: Observable<Loadable<[Section<StoryCellViewModel>], HashableWrapper<SleepTab.Error>>>
	}
	
	let input: Input
	let output: Output
	
	init(
		state: Observable<SleepTab.State>,
		dispatch: @escaping DispatchFunction<SleepTab.Action>
	) {
		self.input = Input()
		self.output = Output(
			contents: state
				.map { $0.sleepStories }
				.map { l in l
				.map { array -> [StoryCellViewModel] in
					return array.map(StoryCellViewModel.init)
				}
				.map(Section.init(items:))
				.map(toArray)
				}
		)
		
		dispatch(.loadSleepStories)
	}
}
