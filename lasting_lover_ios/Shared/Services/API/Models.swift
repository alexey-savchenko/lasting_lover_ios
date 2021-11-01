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
  let seriesDescription: String
  let sort, featured: Int
  let category: [Category]
  let authors: [Author]
  let type: Int
}

extension Series {
  init(dto: SeriesDTO.DTO) {
    self.id = dto.series.id
    self.name = dto.series.name
    self.avatar = dto.series.avatar
    self.seriesDescription = dto.series.seriesDescription
    self.sort = dto.series.sort
    self.featured = dto.series.featured
    self.type = dto.series.type
    self.authors = dto.author.data.compactMap { value -> Author? in
      let data = try? JSONEncoder().encode(value)
      return data.flatMap { d -> Author? in
        return try? JSONDecoder().decode(Author.self, from: d)
      }
    }
    self.category = dto.categories.data.compactMap { value -> Category? in
      let data = try? JSONEncoder().encode(value)
      return data.flatMap { d -> Category? in
        return try? JSONDecoder().decode(Category.self, from: d)
      }
    }
  }
}

enum SeriesDTO {
  // MARK: - SeriesDTO
  struct DTO: Codable {
    let series: SeriesDTO.Series
    let author: SeriesDTO.Author
    let categories: SeriesDTO.Categories
  }
  
  struct Series: Codable {
    let id: Int
    let name: String
    let avatar: String
    let seriesDescription: String
    let type, sort, featured: Int
    
    enum CodingKeys: String, CodingKey {
      case id, name, avatar
      case seriesDescription = "description"
      case type, sort, featured
    }
  }
  
  // MARK: - Author
  struct Author: Codable {
    let data: [Datum]
  }
  
  // MARK: - Datum
  struct Datum: Codable {
    let id: Int
    let name: String
    let avatar: String
    let datumDescription: String
    let age, type: Int
    
    enum CodingKeys: String, CodingKey {
      case id, name, avatar
      case datumDescription = "description"
      case age, type
    }
  }
  
  // MARK: - Categories
  struct Categories: Codable {
    let data: [SeriesDTO.Category]
  }
  
  // MARK: - Series
  struct Category: Codable {
    let id: Int
    let name: String
    let avatar: String
    let seriesDescription: String
    let type, sort, featured: Int
    
    enum CodingKeys: String, CodingKey {
      case id, name, avatar
      case seriesDescription = "description"
      case type, sort, featured
    }
  }
}


struct DiscoverData {
  let authors: [Author]
  let categories: [Category]
  let featuredSeries: [Series]
}

enum StoryType: Int {
  case discover = 1
  case sleep = 2
}
