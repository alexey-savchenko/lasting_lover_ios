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
		let switchTap: AnyObserver<Void>
	}
	
	private let switchTapSubject = PublishSubject<Void>()
	
	struct Output {
		let subtitle: Observable<String>
		let switchIsOn: Observable<Bool>
	}
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<Settings.State>,
		dispatch: @escaping DispatchFunction<Settings.Action>
	) {
		self.input = Input(
			switchTap: switchTapSubject.asObserver()
		)
		self.output = Output(
			subtitle: state.map { state in
				return state.notificationsEnabled ?
				L10n.settingsNotificationsSubtitleSwitchOn :
				L10n.settingsNotificationsSubtitleSwitchOff
			},
			switchIsOn: state.map { state in
				return state.notificationsEnabled
			}
		)
		
		switchTapSubject
			.bind {
				dispatch(.openAppSettings)
			}
			.disposed(by: disposeBag)
	}
}
