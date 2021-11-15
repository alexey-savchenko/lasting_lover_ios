//
//  PlayerItem.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import Foundation

protocol PlayerItemProtocol: Hashable {
	var id: Int { get }
  var title: String { get }
  var authorName: String { get }
  var artworkURL: URL { get }
  var contentURL: URL { get }
}

struct PlayerItem: Hashable, PlayerItemProtocol, Codable {
  let title: String
  let authorName: String
  let artworkURL: URL
  let contentURL: URL
	let id: Int
	let duration: Int
  
  static let mock = PlayerItem(
    title: "Sample title",
    authorName: "Sample author",
    artworkURL: URL(string: "https://picsum.photos/seed/somerandomvalue/500/500")!,
    contentURL: Bundle.main.url(forResource: "placeholderAudio", withExtension: "mp3")!,
		id: 100,
		duration: 100
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
