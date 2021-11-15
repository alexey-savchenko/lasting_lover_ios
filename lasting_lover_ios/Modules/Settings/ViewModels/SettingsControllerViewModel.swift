//
//  SettingsControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import RxSwift
import Dispatch
import RxUNILib
import UNILibCore
import Foundation

class SettingsControllerViewModel {
	struct Input {
		let settingsItemSelectedAtIndex: AnyObserver<IndexPath>
	}
	
	private let settingsItemSelectedAtIndexSubject = PublishSubject<IndexPath>()
	
	struct Output {
		let contents: Observable<[Section<SettingsCellViewModel>]>
		let selectedSettingsItem: Observable<SettingsItem>
	}
	
	let input: Input
	let output: Output
	
	init(
		state: Observable<Settings.State>,
		dispatch: @escaping DispatchFunction<Settings.Action>
	) {
		self.input = Input(
			settingsItemSelectedAtIndex: settingsItemSelectedAtIndexSubject.asObserver()
		)
		self.output = Output(
			contents: state
				.map { state in state.items.map(SettingsCellViewModel.init) }
				.map(Section.init)
				.map(toArray),
			selectedSettingsItem: settingsItemSelectedAtIndexSubject
				.flatMap { index in
					return state.take(1).compactMap { state in
						return state.items[index.item]
					}
				}
		)
	}
}
