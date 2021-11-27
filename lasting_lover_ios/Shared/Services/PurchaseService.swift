//
//  PurchaseService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 27.11.2021.
//

import Foundation
import RxSwift

protocol PurchaseServiceProtocol {
	func purchase(_ iap: IAP) -> Observable<IAP?>
	func restore() -> Observable<IAP?>
}

class MockPurchaseService: PurchaseServiceProtocol {
	func purchase(_ iap: IAP) -> Observable<IAP?> {
		return Observable.create { obs in
			obs.onNext(iap)
			return Disposables.create()
		}
		.delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
	}
	
	func restore() -> Observable<IAP?> {
		return Observable.create { obs in
			obs.onNext(.cherrie_12_month_99_99)
			return Disposables.create()
		}
		.delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
	}
}
