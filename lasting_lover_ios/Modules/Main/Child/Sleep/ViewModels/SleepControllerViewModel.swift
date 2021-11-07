//
//  SleepControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 04.10.2021.
//

import Foundation
import RxSwift
import UNILibCore
import RxUNILib

class SleepControllerViewModel {
	struct Input {
		
	}
	
	struct Output {
		let data: Observable<Loadable<SleepData, HashableWrapper<SleepTab.Error>>>
	}
	
	let input: Input
	let output: Output
	
	init(
		state: Observable<SleepTab.State>,
		dispatch: @escaping DispatchFunction<SleepTab.Action>
	) {
		self.input = Input()
		self.output = Output(
			data: state.map { $0.data }.distinctUntilChanged()
		)
		
		dispatch(.loadData)
	}
}
