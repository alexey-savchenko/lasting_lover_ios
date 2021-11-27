//
//  PolicyModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 26.11.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UIKit

class PolicyModuleCoordinator: RxBaseCoordinator<Void> {
	
	let policy: Policy
	let presentingController: UIViewController
	
	init(policy: Policy, presentingController: UIViewController) {
		self.policy = policy
		self.presentingController = presentingController
	}
	
	override func start() -> Observable<Void> {
		
		var controller: TermsAndConditionsController {
			switch policy {
			case .termsOfUse:
				return TermsAndConditionsController()
			case .privacyPolicy:
				return PrivacyPolicyController()
			}
		}
		controller.modalPresentationStyle = .fullScreen
		
		presentingController.present(controller, animated: true)
		
		return controller.navbarView.backButton.rx.tap
			.do(onNext: { [unowned controller] _ in
				controller.dismiss(animated: true)
			})
	}
	
}
