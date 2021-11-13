//
//  AllSeriesControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UNILibCore

class AllSeriesControllerViewModel {
	struct Input {
		let selectedSeriesAtIndex: AnyObserver<IndexPath>
	}
	
	private let selectedSeriesAtIndexSubject = PublishSubject<IndexPath>()
	
	struct Output {
		let contents: Observable<[Section<AllSeriesCellViewModel>]>
		let selectedSeries: Observable<Series>
	}
	
	private let cellViewModelsSubject = ReplaySubject<[AllSeriesCellViewModel]>.createUnbounded()
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {
		self.input = Input(
			selectedSeriesAtIndex: selectedSeriesAtIndexSubject.asObserver()
		)
		self.output = Output(
			contents: cellViewModelsSubject
				.map(Section.init)
				.map(toArray),
			selectedSeries: selectedSeriesAtIndexSubject
				.flatMap { index in
					return state
						.take(1)
						.compactMap { s -> Series? in
							return s.data.item.map { $0.series[index.item] }
						}
				}
		)
		
		state
			.compactMap { s -> [AllSeriesCellViewModel]? in
				return s.data.item.map { $0.series.map(AllSeriesCellViewModel.init) }
			}
			.subscribe(cellViewModelsSubject)
			.disposed(by: disposeBag)
	}
}
