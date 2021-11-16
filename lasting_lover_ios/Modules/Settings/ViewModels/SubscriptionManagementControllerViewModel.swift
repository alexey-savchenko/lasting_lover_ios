//
//  SubscriptionManagementControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import Foundation
import RxSwift
import RxUNILib

class SubscriptionManagementControllerViewModel {
	struct Input {
		let dismissTap: AnyObserver<Void>
	}
	
	private let dismissTapSubject = PublishSubject<Void>()
	
	struct Output {
		let subtitle: Observable<String>
		let button1Config: Observable<SubscriptionManagementController.ButtonConfig>
		let button2Config: Observable<SubscriptionManagementController.ButtonConfig>
		let dismissTap: Observable<Void>
	}
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<Settings.State>,
		dispatch: @escaping DispatchFunction<Settings.Action>
	) {
		self.input = Input(
			dismissTap: dismissTapSubject.asObserver()
		)
		self.output = Output(
			subtitle: state
				.map { $0.subscriptionActive }
				.map { value in
					return value ?
					L10n.settingsManageSubscriptionSubsribedSubtitle :
					L10n.settingsManageSubscriptionUnsubsribedSubtitle
				},
			button1Config: state.map { state -> SubscriptionManagementController.ButtonConfig in
				return state.subscriptionActive ?
					.shown(title: L10n.settingsCancelSubscription) :
					.shown(title: L10n.settingsSubscribe)
			},
			button2Config: state.map { state -> SubscriptionManagementController.ButtonConfig in
				return state.subscriptionActive ?
					.hidden :
					.shown(title: L10n.settingsRestorePurchase)
			},
			dismissTap: dismissTapSubject.asObservable()
		)
	}
}
