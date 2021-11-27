//
//  SubscriptionService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 09.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol SubscriptionServiceProtocol {
	var subscriptionActive: Bool { get }
	var currentSubscription: IAP? { get }
	var subscriptionActiveObservable: Observable<Bool> { get }
	func setSubscriptionActive(_ product: IAP)
	func setSubscriptionActiveForDebug(_ active: Bool)
}

final class SubscriptionService: SubscriptionServiceProtocol {
	
	static let shared = SubscriptionService()
	
	private let storageService = Current.defaultsStoreService()
	
	private let subSubject = BehaviorRelay<Bool>(value: Current.defaultsStoreService().string(forKey: Constants.UserDefaults.purchasedPlanKey) != nil)
	private let subOverrideSubject = PublishSubject<Bool>()
	private let disposeBag = DisposeBag()
	
	var subscriptionActiveObservable: Observable<Bool> {
		subSubject.asObservable().share(replay: 1, scope: .forever)
	}
	
	var subscriptionActive: Bool {
		subSubject.value
	}
	
	var currentSubscription: IAP? {
		storageService
			.string(forKey: Constants.UserDefaults.purchasedPlanKey)
			.flatMap(IAP.init)
	}
	
	func setSubscriptionActive(_ product: IAP) {
		storageService.set(product.rawValue, forKey: Constants.UserDefaults.purchasedPlanKey)
	}
	
	func setSubscriptionActiveForDebug(_ active: Bool) {
		subOverrideSubject.onNext(active)
	}
	
	private init() {
		let purchasedPlanObservation: Observable<String?> = storageService
			.observeReactive(key: Constants.UserDefaults.purchasedPlanKey) as Observable<String?>
		
		purchasedPlanObservation
			.map { $0 != nil }
			.do(onNext: { active in
				print("Subscription is active == \(active)")
			})
			.subscribe(onNext: subSubject.accept)
			.disposed(by: disposeBag)
		
		subOverrideSubject
			.subscribe(onNext: subSubject.accept)
			.disposed(by: disposeBag)
	}
}
