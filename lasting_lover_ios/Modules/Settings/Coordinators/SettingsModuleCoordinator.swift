//
//  SettingsModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import UIKit
import RxUNILib
import RxSwift
import UNILibCore

class SettingsModuleCoordinator: RxBaseCoordinator<Void> {
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	let navigationController: UINavigationController
	let finishFlow = PublishSubject<Void>()
	
	override func start() -> Observable<Void> {
		let viewModel = SettingsControllerViewModel(
			state: appStore.stateObservable.map { $0.settingsState }.distinctUntilChanged(),
			dispatch: App.Action.settingsAction <*> appStore.dispatch
		)
		let controller = SettingsViewController(viewModel: viewModel)
		
		navigationController.interactivePopGestureRecognizer!.rx
			.observeWeakly(UIGestureRecognizer.State.self, #keyPath(UIGestureRecognizer.state))
			.filterNil()
			.filter { state in
				state == .ended
			}
			.filter { [unowned self, weak controller] _ in
				guard let controller = controller else { return true }
				return !self.navigationController.viewControllers.contains(controller)
			}
			.map(toVoid)
			.subscribe(finishFlow)
			.disposed(by: disposeBag)
		
		navigationController.pushViewController(controller, animated: true)
		
		let backButtonTap: Observable<Void> = controller.navbar.backButton.rx.tap
			.do(onNext: { [unowned navigationController] _ in
				navigationController.popViewController(animated: true)
			})
			.asObservable()
				
				let selectedSettingsItem = viewModel.output.selectedSettingsItem.share()
				
				selectedSettingsItem
				.filter { $0 == .manageSubscription }
				.bind { [unowned self] _ in
					self.presentSubscriptionManagement(navigationController: self.navigationController)
				}
				.disposed(by: disposeBag)
		
		selectedSettingsItem
			.filter { $0 == .notifications }
			.bind { [unowned self] _ in
				self.presentNotificationManagement(navigationController: self.navigationController)
			}
			.disposed(by: disposeBag)
		
		selectedSettingsItem
			.filter { $0 == .termsAndConditions }
			.bind { [unowned self] _ in
				self.presentTermsAndConditions(navigationController: self.navigationController)
			}
			.disposed(by: disposeBag)
		
		selectedSettingsItem
			.filter { $0 == .privacyPolicy }
			.bind { [unowned self] _ in
				self.presentPrivacyPolicy(navigationController: self.navigationController)
			}
			.disposed(by: disposeBag)
		
		
		return Observable
			.merge(backButtonTap, finishFlow)
			.debug()
	}
	
	func presentTermsAndConditions(navigationController: UINavigationController) {
		let c = TermsAndConditionsController()
		navigationController.pushViewController(c, animated: true)
	}
	
	func presentPrivacyPolicy(navigationController: UINavigationController) {
		let c = PrivacyPolicyController()
		navigationController.pushViewController(c, animated: true)
	}
	
	func presentSubscriptionManagement(navigationController: UINavigationController) {
		let vm = SubscriptionManagementControllerViewModel(
			state: appStore.stateObservable.map { $0.settingsState }.distinctUntilChanged(),
			dispatch: App.Action.settingsAction <*> appStore.dispatch
		)
		let c = SubscriptionManagementController(viewModel: vm)
		navigationController.pushViewController(c, animated: true)
	}
	
	func presentNotificationManagement(navigationController: UINavigationController) {
		let vm = NotificationsControllerViewModel(
			state: appStore.stateObservable.map { $0.settingsState }.distinctUntilChanged(),
			dispatch: App.Action.settingsAction <*> appStore.dispatch
		)
		let c = NotificationsController(viewModel: vm)
		navigationController.pushViewController(c, animated: true)
	}
}
