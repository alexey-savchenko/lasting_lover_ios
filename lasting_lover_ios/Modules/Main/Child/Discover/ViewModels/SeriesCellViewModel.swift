//
//  SeriesCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import Foundation
import RxSwift
import UIKit
import RxUNILib

class AllSeriesCellViewModel {
	struct Input {
		let episodesInfo: AnyObserver<String>
	}
	
	struct Output {
		let image: Observable<UIImage>
		let title: String
		let subtitle: String
		let episodeInfo: Observable<String>
	}
	
	private let episodeInfoSubject = ReplaySubject<String>.createUnbounded()
	
	let input: Input
	let output: Output
	
	let series: Series
	
	init(
		series: Series
	) {
		self.series = series
		self.input = Input(
			episodesInfo: episodeInfoSubject.asObserver()
		)
		self.output = Output(
			image: Current.imageLoadingService().image(URL(string: series.avatar)!),
			title: series.name,
			subtitle: series.description,
			episodeInfo: episodeInfoSubject.asObservable().startWith("...")
		)
	}
}
