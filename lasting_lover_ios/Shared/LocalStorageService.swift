//
//  LocalStorageService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import Foundation

protocol LocalStorageServiceProtocol {
  var userToken: String { get set }
}

struct LocalStorageService: LocalStorageServiceProtocol {
  var userToken: String {
    get {
      return Current.defaultsStoreService().string(forKey: #function) ?? ""
    }
    set {
      Current.defaultsStoreService().setObject(newValue, forKey: #function)
    }
  }
}
