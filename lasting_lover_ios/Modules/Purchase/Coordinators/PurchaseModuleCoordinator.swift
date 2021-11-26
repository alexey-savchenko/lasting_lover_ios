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
		case purchased(value: IAP)
		case dismissed
		case restored
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
			dismiss: false
		),
		middleware: [],
		reducer: PurchaseModule.reducer
	)
	
	override func start() -> Observable<Result> {
		
		let viewModel = PurchaseControllerViewModel(
			state: store.stateObservable,
			dispatch: store.dispatch
		)
		let controller = PurchaseController(viewModel: viewModel)
		
		navigationController.present(controller, animated: true)
		
		return .never()
		
	}
}
