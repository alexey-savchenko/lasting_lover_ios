//
//  FavoritesService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 18.10.2021.
//

import Foundation

protocol FavoritesServiceProtocol {
  func addFavorite(_ item: Story)
  func removeFavorite(_ item: Story)
  func favoriteItems() -> [Story]
}

class FavoritesService: FavoritesServiceProtocol {
  func addFavorite(_ item: Story) {
    let items = Current.localStorageService().favoriteItems
    let updatedItems = items + [item]
    Current.localStorageService().favoriteItems = updatedItems
  }
  
  func removeFavorite(_ item: Story) {
    let items = Current.localStorageService().favoriteItems
    let updatedItems = items.filter { $0 != item }
    Current.localStorageService().favoriteItems = updatedItems
  }
  
  func favoriteItems() -> [Story] {
    return Current.localStorageService().favoriteItems
  }
}
