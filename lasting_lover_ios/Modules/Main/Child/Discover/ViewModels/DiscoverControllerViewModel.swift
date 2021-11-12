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
  }
  
	private let selectedAuthorAtIndexSubject = PublishSubject<IndexPath>()
	
  struct Output {
		let data: Observable<Loadable<DiscoverData, HashableWrapper<DiscoverTab.Error>>>
		let selectedAuthor: Observable<Author>
  }
  
  let input: Input
  let output: Output
  
	init(
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {
    self.input = Input(
			selectedAuthorAtIndex: selectedAuthorAtIndexSubject.asObserver()
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
				}
		)
		
		dispatch(.loadData)
  }
}
