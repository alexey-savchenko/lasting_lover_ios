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
			.map { $0.data }
			.distinctUntilChanged()
			.compactMap { s -> [AllSeriesCellViewModel]? in
				return s.item.map { $0.series.map(AllSeriesCellViewModel.init) }
			}
			.subscribe(cellViewModelsSubject)
			.disposed(by: disposeBag)
		
		state
			.bind { state in
				state.data.item
					.map { data in
						data.series
							.forEach { s in
								dispatch(.loadSeriesStories(value: s))
							}
					}
			}
			.disposed(by: disposeBag)

		state
			.map { $0.seriesStories }
			.withLatestFrom(cellViewModelsSubject) { ($0, $1) }
			.bind { state, vms in
				vms.forEach { vm in
					if let stories = state[vm.series]?.item {
						let duration = stories.map { $0.audioDuration }.reduce(0, +)
						var durationString: String {
							let minutes = duration / 60
							if minutes > 60 {
								let doubleTime = Double(minutes) / 60.0
								let hours = Double(Int(doubleTime))
								let minutes = (doubleTime - hours) * 60
								return "\(Int(hours))h \(Int(minutes))m"
							} else {
								return "\(minutes) min"
							}
						}
						let resultString = "\(stories.count) episodes - \(durationString)"
						vm.input.episodesInfo.onNext(resultString)
					}
				}
			}
			.disposed(by: disposeBag)
	}
}
