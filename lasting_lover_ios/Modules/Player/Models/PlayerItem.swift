//
//  PlayerItem.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import Foundation

protocol PlayerItemProtocol {
  var title: String { get }
  var author: String { get }
  var artworkURL: URL { get }
}

enum PlayerItem: Hashable {
  
  case mock
  
  var title: String {
    switch self {
    case .mock:
      return "Sample title"
    }
  }
  var author: String {
    switch self {
    case .mock:
      return "Sample author"
    }
  }
  var artworkURL: URL {
    switch self {
    case .mock:
      return Bundle.main.url(forResource: "placeholder", withExtension: "png")!
    }
  }
}
