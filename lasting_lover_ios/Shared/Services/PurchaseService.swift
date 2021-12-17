//
//  PurchaseService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 27.11.2021.
//

import Foundation
import RxSwift
import SwiftyStoreKit

protocol PurchaseServiceProtocol {
	func purchase(_ iap: IAP) -> Observable<IAP?>
	func restore(forceRefresh: Bool) -> Observable<IAP?>
}

final class PurchaseService: PurchaseServiceProtocol {
	
	func purchase(_ iap: IAP) -> Observable<IAP?> {
		return Observable.create { obs in
			
			SwiftyStoreKit.purchaseProduct(iap.rawValue) { result in
				switch result {
				case .success:
					obs.onNext(iap)
				case .error:
					obs.onNext(nil)
				}
			}
			
			return Disposables.create()
		}
	}
	
	func restore(forceRefresh: Bool) -> Observable<IAP?> {
		return Observable.create { obs in
			
			SwiftyStoreKit
				.verifyReceipt(
					using: AppleReceiptValidator(
						service: .production,
						sharedSecret: Constants.Other.sharedSecret
					),
					forceRefresh: forceRefresh
				) { result in
					switch result {
					case .error:
						obs.onNext(nil)
					case .success(let receipt):
						let results = SwiftyStoreKit.verifySubscriptions(
							productIds: Set(IAP.allCases.map { $0.rawValue }),
							inReceipt: receipt
						)

						var purchased: [ReceiptItem] = []
						
						switch results {
						case .purchased(_, let items):
							purchased = items
						default:
							break
						}
						
						if purchased.isEmpty {
							obs.onNext(nil)
						} else {
							for res in purchased {
								if let subscriptionExpirationDate = res.subscriptionExpirationDate {
									if res.cancellationDate == nil {
										let currentDate = Date()
										if currentDate < subscriptionExpirationDate {
											let iap = IAP(rawValue: res.productId)
											obs.onNext(iap)
											return
										}
									}
								}
							}
						}
						obs.onNext(nil)
					}
				}
			
			return Disposables.create()
		}
	}
	
}

class MockPurchaseService: PurchaseServiceProtocol {
	func purchase(_ iap: IAP) -> Observable<IAP?> {
		return Observable.create { obs in
			obs.onNext(iap)
			return Disposables.create()
		}
		.debounce(.seconds(3), scheduler: MainScheduler.instance)
	}
	
	func restore(forceRefresh: Bool) -> Observable<IAP?> {
		return Observable.create { obs in
			obs.onNext(nil)
			return Disposables.create()
		}
		.debounce(.seconds(3), scheduler: MainScheduler.instance)
	}
}
