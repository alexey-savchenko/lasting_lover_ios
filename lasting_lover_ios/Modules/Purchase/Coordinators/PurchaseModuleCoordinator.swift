//
//  PurchaseScreenModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import Foundation
import RxUNILib
import UIKit
import SwiftyStoreKit
import RxSwift

class PurchaseModuleCoordinator: RxBaseCoordinator<PurchaseModuleCoordinator.Result> {
	
	enum Result {
		case purchasedOrRestored
		case dismissed
	}
	
	let navigationController: UINavigationController
	let origin: PurchaseScreenOrigin
	
	init(
		navigationController: UINavigationController,
		origin: PurchaseScreenOrigin
	) {
		self.navigationController = navigationController
		self.origin = origin
	}
	
	lazy var store = RxStore<PurchaseModule.State, PurchaseModule.Action>(
		inputState: PurchaseModule.State(
			isLoading: false,
			origin: origin,
			selectedIAP: nil,
			dismiss: false,
			error: nil,
			purchasedOrRestored: false
		),
		middleware: [PurchaseModule.middleware],
		reducer: PurchaseModule.reducer
	)
	
	override func start() -> Observable<Result> {
		let viewModel = PurchaseControllerViewModel(
			state: store.stateObservable,
			dispatch: store.dispatch
		)
		let controller = PurchaseController(viewModel: viewModel)
		controller.modalPresentationStyle = .fullScreen
		
		viewModel.output.policyTap
			.flatMap { [unowned self, unowned controller] value in
				return self.presentPolicyModule(
					policy: value,
					presentingController: controller
				)
			}
			.subscribe()
			.disposed(by: disposeBag)
		
		navigationController.present(controller, animated: true)
		
		let dismiss = store.stateObservable
			.map { $0.dismiss }
			.filter { $0 }
			.map { _ in Result.dismissed }
		let purchaseOrRestore = store.stateObservable
			.map { $0.purchasedOrRestored }
			.filter { $0 }
			.map { _ in  Result.purchasedOrRestored }
		
		return Observable
			.merge(dismiss, purchaseOrRestore)
			.do(onNext: { [unowned controller] _ in
				controller.dismiss(animated: true)
			})
	}
	
	func presentPolicyModule(policy: Policy, presentingController: UIViewController) -> Observable<Void> {
		let coordinator = PolicyModuleCoordinator(
			policy: policy,
			presentingController: presentingController
		)
		return coordinate(to: coordinator)
	}
}
