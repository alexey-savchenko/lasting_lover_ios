//
//  BackendService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 31.10.2021.
//

import Foundation
import Moya
import Alamofire
import RxSwift
import RxMoya

protocol BackendServiceProtocol {
  func getDiscoverData() -> Observable<DiscoverData>
}

class BackendService {
  let provider = MoyaProvider<Backend>()
  
  static let shared = BackendService()
  
  private init() {
    provider.session.sessionConfiguration.timeoutIntervalForRequest = 10
  }
  
  func getDiscoverData() -> Observable<DiscoverData> {
    fatalError()
//    let discoverAuthors = provider.rx.request(.discoverAuthors).map(BackendResponse<Author>.self)
//    let discoverCategories = provider.rx.request(.discoverCategories).map(BackendResponse<Category>.self)
//    return Observable
//      .zip([discoverAuthors, discoverCategories])
//      .map { authors, categories in
//
//      }
  }
}

enum Backend {
  case discoverAuthors
  case authorDetails(id: String)
  case discoverCategories
  case discoverSeries(featured: Bool)
  case sleepCategories
  case listStories(type: StoryRequestType)
}

enum StoryRequestType {
  case storyByID(id: String)
  case allStories(featured: Bool, type: StoryType)
  case storiesByCategory(categoryID: String, featured: Bool, type: StoryType)
  case storiesBySeries(seriesID: String, featured: Bool, type: StoryType)
  case storiesByAuthor(authorID: String, featured: Bool, type: StoryType)
}

extension Backend: TargetType {
  
  var baseURL: URL {
    return Constants.Backend.apiURL
  }
  
  var path: String {
    switch self {
    case .authorDetails: return "/author"
    case .discoverAuthors: return "/discover/authors"
    case .discoverCategories: return "/discover/categories"
    case .discoverSeries: return "/discover/series"
    case .listStories: return "/story"
    case .sleepCategories: return "/sleep/categories"
    }
  }
  
  var method: HTTPMethod {
    return Method.get
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    
    var params: [String: Any] = ["key": Constants.Backend.apiKEY]
    
    switch self {
    case .authorDetails(let id):
      params["id"] = id
    case .discoverAuthors: break
    case .discoverCategories: break
    case .discoverSeries(let featured):
      if featured {
        params["featured"] = 1
      }
    case .listStories(let type):
      switch type {
      case .allStories(let featured, let type):
        if featured {
          params["featured"] = 1
        }
        params["type"] = type.rawValue
      case .storiesByAuthor(let authorID, let featured, let type):
        if featured {
          params["featured"] = 1
        }
        params["type"] = type.rawValue
        params["author"] = authorID
      case .storiesByCategory(let categoryID, let featured, let type):
        if featured {
          params["featured"] = 1
        }
        params["type"] = type.rawValue
        params["category"] = categoryID
      case .storiesBySeries(let seriesID, let featured, let type):
        if featured {
          params["featured"] = 1
        }
        params["type"] = type.rawValue
        params["series"] = seriesID
      case .storyByID(let id):
        params["id"] = id
      }
    case .sleepCategories: break
    }
    
    return Task.requestParameters(
      parameters: params,
      encoding: URLEncoding.default
    )
  }
  
  var headers: [String : String]? {
    return nil
  }
}
