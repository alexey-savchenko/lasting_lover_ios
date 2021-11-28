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
  var favoriteItems: [Story] { get set }
	var notificationsToken: String { get set }
	var shownOnboarding: Bool { get set }
}

class LocalStorageService: LocalStorageServiceProtocol {
	var shownOnboarding: Bool {
		get {
			return Current.defaultsStoreService().getObject(forKey: #function) ?? false
		}
		set {
			Current.defaultsStoreService().setObject(newValue, forKey: #function)
		}
	}
  var favoriteItems: [Story] {
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
