//
//  NotificationsControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import Foundation
import RxSwift
import RxUNILib

class NotificationsControllerViewModel {
	struct Input {
		
	}
	
	struct Output {
		let subtitle: Observable<String>
	}
	
	let input: Input
	let output: Output
	
	init(
		state: Observable<Settings.State>,
		dispatch: @escaping DispatchFunction<Settings.Action>
	) {
		self.input = Input()
		self.output = Output(
			subtitle: state.map { state in
				return state.notificationsEnabled ?
				L10n.settingsNotificationsSubtitleSwitchOn :
				L10n.settingsNotificationsSubtitleSwitchOff
			}
		)
	}
}
