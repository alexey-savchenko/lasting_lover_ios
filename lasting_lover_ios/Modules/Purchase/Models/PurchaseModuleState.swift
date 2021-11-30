//
//  PurchaseModuleState.swift.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 25.11.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import RxSwift

enum PurchaseModule {
	
	enum Error: LocalizedError {
		case purchaseUnsuccessful
		case noPurchasesToRestore
		
		var noPurchasesToRestore: String? {
			switch self {
			case .purchaseUnsuccessful:
				return L10n.purchaseUnsuccessful
			case .noPurchasesToRestore:
				return L10n.noPurchasesToRestore
			}
		}
	}
	
	/// sourcery: lens
	struct State: Hashable {
		let isLoading: Bool
		let origin: PurchaseScreenOrigin
		let selectedIAP: IAP?
		let dismiss: Bool
		let error: HashableWrapper<PurchaseModule.Error>?
		let purchasedOrRestored: Bool
	}
	
	enum Action {
		case selectedIAP(value: IAP)
		case setIsLoading(value: Bool)
		case dismissTap
		case purchase
		case restore
		case setError(value: PurchaseModule.Error)
		case successfulPurchaseOrRestore
	}
	
	static let middleware: Middleware<PurchaseModule.State, PurchaseModule.Action> = { dispatch, getState in
		{ next in
			{ action in
				switch action {
				case .selectedIAP, .setIsLoading, .dismissTap:
					next(action)
				case .purchase:
					
					guard
						let state = getState(),
						let selectedIAP = state.selectedIAP
					else { next(action); return }
					dispatch(.setIsLoading(value: true))
					var d: Disposable?
					d = Current.purchaseService()
						.purchase(selectedIAP)
						.subscribe(onNext: { value in
							dispatch(.setIsLoading(value: false))
							if let value = value {
								Current.subscriptionService().setSubscriptionActive(value)
								appStore.dispatch(.settingsAction(action: .setSubscriptionActive(value: true)))
								dispatch(.successfulPurchaseOrRestore)
							} else {
								dispatch(.setError(value: .purchaseUnsuccessful))
							}
							
							d?.dispose()
						})
				case .restore:
					dispatch(.setIsLoading(value: true))
					var d: Disposable?
					d = Current.purchaseService()
						.restore()
						.subscribe(onNext: { value in
							dispatch(.setIsLoading(value: false))
							if let value = value {
								Current.subscriptionService().setSubscriptionActive(value)
								appStore.dispatch(.settingsAction(action: .setSubscriptionActive(value: true)))
								dispatch(.successfulPurchaseOrRestore)
							} else {
								dispatch(.setError(value: .noPurchasesToRestore))
							}
							
							d?.dispose()
						})
				case .setError:
					next(action)
				case .successfulPurchaseOrRestore:
					next(action)
				}
			}
		}
	}
	
	static let reducer = Reducer<PurchaseModule.State, PurchaseModule.Action> { state, action in
		switch action {
		case .purchase, .restore:
			return state
		case .dismissTap:
			return PurchaseModule.State.lens.dismiss.set(true)(state)
		case .setError(let value):
			return PurchaseModule.State.lens.error.set(.init(value: value))(state)
		case .successfulPurchaseOrRestore:
			return PurchaseModule.State.lens.purchasedOrRestored.set(true)(state)
		case .selectedIAP(let value):
			return PurchaseModule.State.lens.selectedIAP.set(value)(state)
		case .setIsLoading(let value):
			return PurchaseModule.State.lens.isLoading.set(value)(state)
		}
	}
}
