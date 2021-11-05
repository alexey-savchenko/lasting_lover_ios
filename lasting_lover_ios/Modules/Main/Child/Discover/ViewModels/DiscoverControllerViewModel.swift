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
    
  }
  
  struct Output {
		let errors: Observable<LocalizedError>
		let data: Observable<DiscoverData>
  }
  
  let input: Input
  let output: Output
  
	init(
		state: Observable<Discover.State>,
		dispatch: @escaping DispatchFunction<Discover.Action>
	) {
    self.input = Input()
		self.output = Output(
			errors: state
				.map { $0.data }
				.compactMap { value -> HashableWrapper<Discover.Error>? in
					if case .error(let wrapped) = value {
						return wrapped
					} else {
						return nil
					}
				}
				.distinctUntilChanged()
				.map { $0.value },
			data: state
				.map { $0.data }
				.compactMap { value -> DiscoverData? in
					if case .item(let item) = value {
						return item
					} else {
						return nil
					}
				}
				.distinctUntilChanged()
		)
		
		dispatch(.loadData)
  }
}
