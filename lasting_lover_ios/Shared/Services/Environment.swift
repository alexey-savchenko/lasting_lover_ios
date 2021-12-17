//
//  Environment.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import Foundation

struct Environment {
  var defaultsStoreService: () -> DefaultsStoreServiceProtocol = { UserDefaults.standard }
  var localStorageService: () -> LocalStorageServiceProtocol = { LocalStorageService() }
  var playerService: () -> AudioPlayerServiceProtocol = { AudioPlayerService.shared }
  var favoritesService: () -> FavoritesServiceProtocol = { FavoritesService() }
  var imageLoadingService: () -> ImageLoadingServiceProtocol = { ImageLoadingService.shared }
	var backend: () -> BackendServiceProtocol = { BackendService.shared }
	var subscriptionService: () -> SubscriptionServiceProtocol = { SubscriptionService.shared }
	var listentedItemsService: () -> ListenedItemsServiceProtocol = { ListenedItemsService() }
	var purchaseScreenFactory: () -> PuchaseScreenFactoryProtocol = { PuchaseScreenFactory() }
	var purchaseService: () -> PurchaseServiceProtocol = {
		PurchaseService()
//		MockPurchaseService()
	}
}

#if DEBUG
  var Current = Environment()
#else
  let Current = Environment()
#endif
