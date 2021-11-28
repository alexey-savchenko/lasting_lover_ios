//
//  WelcomeModuleController.swift.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 28.11.2021.
//

import Foundation
import RxUNILib
import UIKit
import RxSwift

class WelcomeModuleCoordinator: RxBaseCoordinator<Void> {
	
	let presentingController: UINavigationController
	
	init(presentingController: UINavigationController) {
		self.presentingController = presentingController
	}
	
	override func start() -> Observable<Void> {
		
		let controller = WelcomeController()
		
		presentingController.setViewControllers([controller], animated: false)
		controller.presentPurchaseScreen
			.flatMap { [unowned self] _ in
				self.presentPurchaseModule(navigationController: self.presentingController, origin: .appLaunch)
			}
			.bind { [unowned controller] _ in
				controller.stageSubject.accept(.finish)
			}
			.disposed(by: disposeBag)
		
		return controller.finishFlow
	}
	
	func presentPurchaseModule(
		navigationController: UINavigationController,
		origin: PurchaseScreenOrigin
	) -> Observable<Bool> {
		let coordinator = PurchaseModuleCoordinator(
			navigationController: navigationController,
			origin: origin
		)
		return coordinate(to: coordinator).map { result in
			return result == .purchasedOrRestored
		}
	}
}
