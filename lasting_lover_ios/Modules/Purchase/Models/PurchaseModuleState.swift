//
//  PurchaseModuleState.swift.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 25.11.2021.
//

import Foundation
import UNILibCore

enum PurchaseModule {
	
	/// sourcery: lens
	struct State: Hashable {
		let isLoading: Bool
		let origin: PurchaseScreenOrigin
		let selectedIAP: IAP?
		let dismiss: Bool
	}
	
	enum Action {
		case selectedIAP(value: IAP)
		case setIsLoading(value: Bool)
		case dismissTap
		case purchase
		case restore
	}
	
	static let reducer = Reducer<PurchaseModule.State, PurchaseModule.Action> { state, action in
		switch action {
		case .purchase, .restore:
			return state
		case .dismissTap:
			return PurchaseModule.State.lens.dismiss.set(true)(state)
		case .selectedIAP(let value):
			return PurchaseModule.State.lens.selectedIAP.set(value)(state)
		case .setIsLoading(let value):
			return PurchaseModule.State.lens.isLoading.set(value)(state)
		}
	}
}
