//
//  LocalStorageService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import Foundation

protocol LocalStorageServiceProtocol: AnyObject {
  var userToken: String { get set }
  var isSubsctiptionActive: Bool { get set }
  var favoriteItems: [PlayerItem] { get set }
	var notificationsToken: String { get set }
}

class LocalStorageService: LocalStorageServiceProtocol {
  var favoriteItems: [PlayerItem] {
    get {
      return Current.defaultsStoreService().getObject(forKey: #function) ?? []
    }
    set {
      Current.defaultsStoreService().setObject(newValue, forKey: #function)
    }
  }
  var userToken: String {
    get {
      return Current.defaultsStoreService().string(forKey: #function) ?? ""
    }
    set {
      Current.defaultsStoreService().setObject(newValue, forKey: #function)
    }
  }
	var notificationsToken: String {
		get {
			return Current.defaultsStoreService().string(forKey: #function) ?? ""
		}
		set {
			Current.defaultsStoreService().setObject(newValue, forKey: #function)
		}
	}
  var isSubsctiptionActive: Bool {
    get {
      return Current.defaultsStoreService().bool(forKey: #function)
    }
    set {
      Current.defaultsStoreService().setObject(newValue, forKey: #function)
    }
  }
}
