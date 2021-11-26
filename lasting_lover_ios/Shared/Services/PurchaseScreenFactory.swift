//
//  PurchaseScreenFactory.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 25.11.2021.
//

import Foundation

protocol PuchaseScreenFactoryProtocol {
	func make(from origin: PurchaseScreenOrigin) -> PurchaseScreenViewProtocol
}
 
struct PuchaseScreenFactory: PuchaseScreenFactoryProtocol {
	func make(from origin: PurchaseScreenOrigin) -> PurchaseScreenViewProtocol {
		switch origin {
		case .appLaunch:
			return StarterPurchaseScreenView()
		case .settings:
			return StarterPurchaseScreenView()
		case .storyPlay:
			return StarterPurchaseScreenView()
		}
	}
}
