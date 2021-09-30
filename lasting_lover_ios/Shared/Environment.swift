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
}

#if DEBUG
var Current = Environment()
#else
let Current = Environment()
#endif
