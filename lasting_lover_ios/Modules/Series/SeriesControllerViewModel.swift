//
//  SeriesControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import Foundation
import RxSwift
import UIKit
import UNILibCore
import RxUNILib

class SeriesControllerViewModel {
	struct Input {
		
	}
	
	struct Output {
		let title: String
		let subtitle: String
		let image: Observable<UIImage>
		let authors: Observable<[Section<AuthorCellViewModel>]>
		let categories: Observable<[Section<SleepCategoryCellViewModel>]>
		let stories: Observable<Loadable<[StoryCellViewModel], HashableWrapper<AppError>>>
	}
	
	let input: Input
	let output: Output
	
	init(
		series: Series,
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {
		
		dispatch(.loadSeriesStories(value: series))
		
		self.input = Input()
		self.output = Output(
			title: series.name,
			subtitle: series.description,
			image: Current.imageLoadingService().image(URL(string: series.avatar)!),
			authors: Observable.just(series.authors.map(AuthorCellViewModel.init)).map(Section.init).map(toArray),
			categories: Observable.just(series.categories.map(SleepCategoryCellViewModel.init)).map(Section.init).map(toArray),
			stories: state.compactMap { $0.seriesStories[series]?.map { $0.map(StoryCellViewModel.init) } }
		)
		
	}
}
