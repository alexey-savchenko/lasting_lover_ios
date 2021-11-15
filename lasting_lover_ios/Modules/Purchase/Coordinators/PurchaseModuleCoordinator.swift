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
	
	
  
}
