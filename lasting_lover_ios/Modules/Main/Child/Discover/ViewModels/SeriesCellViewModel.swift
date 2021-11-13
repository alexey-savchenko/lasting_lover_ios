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
		
	}
	
	struct Output {
		let image: Observable<UIImage>
		let title: String
		let subtitle: String
		let episodeCount: Observable<String>
	}
	
	private let episodeCountSubject = ReplaySubject<String>.createUnbounded()
	
	let input: Input
	let output: Output
	
	let series: Series
	
	init(
		series: Series
	) {
		self.series = series
		self.input = Input()
		self.output = Output(
			image: Current.imageLoadingService().image(URL(string: series.avatar)!),
			title: series.name,
			subtitle: series.description,
			episodeCount: episodeCountSubject.asObservable().startWith("...")
		)
	}
}
