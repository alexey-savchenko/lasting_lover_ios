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
		let data: Observable<Loadable<DiscoverData, HashableWrapper<Discover.Error>>>
  }
  
  let input: Input
  let output: Output
  
	init(
		state: Observable<Discover.State>,
		dispatch: @escaping DispatchFunction<Discover.Action>
	) {
    self.input = Input()
		self.output = Output(
			data: state.map { $0.data }.distinctUntilChanged()
		)
		
		dispatch(.loadData)
  }
}
