//
//  ListenedItemsService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 09.11.2021.
//

import Foundation
import RxSwift

protocol ListenedItemsServiceProtocol {
	func hadListened(_ audioitemID: Int) -> Observable<Bool>
	func setListened(_ audioitemID: Int)
}

class ListenedItemsService: ListenedItemsServiceProtocol {
	let defaults = Current.defaultsStoreService()
	
	lazy var allListenedIDs: Observable<[Int]> = {
		return (defaults.observeReactive(key: #function) as Observable<[Int]?>).map { $0 ?? [] }
	}()
	
	var allListenedIDsSync: [Int] {
		return defaults.getObject(forKey: "allListenedIDs") ?? []
	}
	
	func hadListened(_ audioitemID: Int) -> Observable<Bool> {
		return allListenedIDs.map { $0.contains(audioitemID) }
	}
	
	func setListened(_ audioitemID: Int) {
		let idsToSet = Set(allListenedIDsSync + [audioitemID])
		defaults.set(idsToSet, forKey: "allListenedIDs")
	}
}
