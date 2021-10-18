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
  var contentURL: URL { get }
}

struct _PlayerItem: Hashable, PlayerItemProtocol, Codable {
  let title: String
  let author: String
  let artworkURL: URL
  let contentURL: URL
  
  static let mock = _PlayerItem(
    title: "Sample title",
    author: "Sample author",
    artworkURL: Bundle.main.url(forResource: "placeholder", withExtension: "png")!,
    contentURL: Bundle.main.url(forResource: "placeholderAudio", withExtension: "mp3")!
  )
}
//
//enum PlayerItem: Hashable, PlayerItemProtocol {
//
//  case mock
//
//  var title: String {
//    switch self {
//    case .mock:
//      return "Sample title"
//    }
//  }
//  var author: String {
//    switch self {
//    case .mock:
//      return "Sample author"
//    }
//  }
//  var artworkURL: URL {
//    switch self {
//    case .mock:
//      return Bundle.main.url(forResource: "placeholder", withExtension: "png")!
//    }
//  }
//
//  var contentURL: URL {
//    switch self {
//    case .mock:
//      return Bundle.main.url(forResource: "placeholderAudio", withExtension: "mp3")!
//    }
//  }
//}
