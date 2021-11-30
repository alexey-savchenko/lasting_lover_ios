//
//  SubscriptionManagementControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UIKit
import UNILibCore

class SubscriptionManagementControllerViewModel {
	struct Input {
		let primaryButtonTap: AnyObserver<Void>
		let secondaryButtonTap: AnyObserver<Void>
		let dismissTap: AnyObserver<Void>
	}
	
	private let dismissTapSubject = PublishSubject<Void>()
	private let primaryButtonTapSubject = PublishSubject<Void>()
	private let secondaryButtonTapSubject = PublishSubject<Void>()
	
	struct Output {
		let subtitle: Observable<String>
		let button1Config: Observable<SubscriptionManagementController.ButtonConfig>
		let button2Config: Observable<SubscriptionManagementController.ButtonConfig>
		let dismissTap: Observable<Void>
		let showPurchaseScreen: Observable<Void>
		let showSubManageScreen: Observable<Void>
		let isLoading: Observable<Bool>
		let error: Observable<LocalizedError>
	}
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<Settings.State>,
		dispatch: @escaping DispatchFunction<Settings.Action>
	) {
		self.input = Input(
			primaryButtonTap: primaryButtonTapSubject.asObserver(),
			secondaryButtonTap: secondaryButtonTapSubject.asObserver(),
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
			button1Config: state.map { $0.subscriptionActive }.distinctUntilChanged()
				.debug()
				.map { state -> SubscriptionManagementController.ButtonConfig in
					return state ?
						.shown(title: L10n.settingsCancelSubscription) :
						.shown(title: L10n.settingsSubscribe)
				},
			button2Config: state.map { $0.subscriptionActive }.distinctUntilChanged()
				.debug()
				.map { state -> SubscriptionManagementController.ButtonConfig in
					return state ?
						.hidden :
						.shown(title: L10n.settingsRestorePurchase)
				},
			dismissTap: dismissTapSubject.asObservable(),
			showPurchaseScreen: primaryButtonTapSubject
				.withLatestFrom(state.map { $0.subscriptionActive })
				.filter { !$0 }
				.map(toVoid),
			showSubManageScreen: primaryButtonTapSubject
				.withLatestFrom(state.map { $0.subscriptionActive })
				.filter { $0 }
				.map(toVoid),
			isLoading: state.map { $0.isLoading },
			error: state.map { $0.errors }.filterNil().distinctUntilChanged().map { $0.value } 
		)
		
		secondaryButtonTapSubject
			.withLatestFrom(state.map { $0.subscriptionActive })
			.filter { !$0 }
			.bind { _ in
				dispatch(.restorePurchase)
			}
			.disposed(by: disposeBag)
	}
}
