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
	func hadListened(_ audioitemID: Int) -> Bool
	func setListened(_ audioitemID: Int)
}

class ListenedItemsService: ListenedItemsServiceProtocol {
	let defaults = Current.defaultsStoreService()
	
	lazy var allListenedIDs: Observable<[Int]> = {
		let key = #function
		return (defaults.observeReactive(key: key) as Observable<[Int]?>).map { $0 ?? [] }
	}()
	
	var allListenedIDsSync: [Int] {
		return defaults.getObject(forKey: "allListenedIDs") ?? []
	}
	
	func hadListened(_ audioitemID: Int) -> Observable<Bool> {
		return allListenedIDs.map { $0.contains(audioitemID) }
	}
	
	func hadListened(_ audioitemID: Int) -> Bool {
		return allListenedIDsSync.contains(audioitemID)
	}
	
	func setListened(_ audioitemID: Int) {
		let initialIDs = allListenedIDsSync
		let idsToSet = Set(initialIDs + [audioitemID]).flatMap { $0 }
		defaults.setObject(idsToSet, forKey: "allListenedIDs")
	}
}
