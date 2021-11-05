//
//  Models.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 31.10.2021.
//

import Foundation

struct BackendResponse<T: Codable>: Codable {
  let status: BackendResponseStatus
  let data: [T]
}

enum BackendResponseStatus: String, Codable {
  case success
}

struct Author: Codable, Hashable {
  let id: Int
  let name: String
  let avatar: String
  let authorDescription: String
  let age, type: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name, avatar
    case authorDescription = "description"
    case age, type
  }
}

struct Category: Codable, Hashable {
  let id: Int
  let name: String
  let avatar: String
  let categoryDescription: String
  let type, sort, featured: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name, avatar
    case categoryDescription = "description"
    case type, sort, featured
  }
}

// MARK: - Series
struct Series: Codable, Hashable {
  let id: Int
  let name: String
  let avatar: String
  let description: String
  let sort, featured: Int
  let categories: [Category]
  let authors: [Author]
  let type: Int
}

struct DiscoverData: Hashable {
  let authors: [Author]
  let categories: [Category]
  let featuredSeries: [Series]
}

enum StoryType: Int {
  case discover = 1
  case sleep = 2
}
