//
//  DiscoverControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 04.10.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UNILibCore

class DiscoverControllerViewModel {
  struct Input {
		let selectedAuthorAtIndex: AnyObserver<IndexPath>
		let allSeriesButtonTap: AnyObserver<Void>
		let featuredSeriesSelectedAtIndex: AnyObserver<IndexPath>
  }
  
	private let selectedAuthorAtIndexSubject = PublishSubject<IndexPath>()
	private let allSeriesButtonTapSubject = PublishSubject<Void>()
	private let featuredSeriesSelectedAtIndexSubject = PublishSubject<IndexPath>()
	
  struct Output {
		let data: Observable<Loadable<DiscoverData, HashableWrapper<AppError>>>
		let selectedAuthor: Observable<Author>
		let allSeriesButtonTap: Observable<Void>
		let selectedFeaturedSeries: Observable<Series>
  }
  
  let input: Input
  let output: Output
  
	init(
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {
    self.input = Input(
			selectedAuthorAtIndex: selectedAuthorAtIndexSubject.asObserver(),
			allSeriesButtonTap: allSeriesButtonTapSubject.asObserver(),
			featuredSeriesSelectedAtIndex: featuredSeriesSelectedAtIndexSubject.asObserver()
		)
		self.output = Output(
			data: state.map { $0.data }.distinctUntilChanged(),
			selectedAuthor: selectedAuthorAtIndexSubject
				.flatMap { index -> Observable<Author> in
					return state.take(1).compactMap { state -> Author? in
						if case .item(let value) = state.data {
							return value.authors[safe: index.item]
						} else {
							return nil
						}
					}
				},
			allSeriesButtonTap: allSeriesButtonTapSubject.asObservable(),
			selectedFeaturedSeries: featuredSeriesSelectedAtIndexSubject
				.flatMap { index in
					return state.take(1).compactMap { state in
						return state.data.item.map { data in
							return data.series.filter { $0.featured == 1 }.prefix(2)[index.item]
						}
					}
			}
		)
		
		dispatch(.loadData)
  }
}
