//
//  ImageLoadingService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 22.10.2021.
//

import UIKit
import RxSwift

protocol ImageLoadingServiceProtocol {
  func image(_ url: URL) -> Observable<UIImage>
  func image(_ url: URL, completion: @escaping (UIImage) -> Void)
}

class ImageLoadingService: ImageLoadingServiceProtocol {
  
  var cachedImageNames: [String] = []
  
  private init() {
    if FileManager.default.fileExists(atPath: Constants.Directory.imageCache.path) {
      cachedImageNames = (try? FileManager.default.contentsOfDirectory(
        at: Constants.Directory.imageCache,
        includingPropertiesForKeys: nil,
        options: []
      ))
        .map { urls in
          return urls.map { url in
            url.deletingPathExtension().lastPathComponent
          }
        } ?? []
    } else {
      try? FileManager.default.createDirectory(
        at: Constants.Directory.imageCache,
        withIntermediateDirectories: true,
        attributes: nil
      )
    }
  }
  
  static let shared = ImageLoadingService()
  
  func image(_ url: URL) -> Observable<UIImage> {
    return Observable.create { obs in
      self.image(url) { image in
        obs.onNext(image)
      }
      return Disposables.create()
    }
  }
  
  fileprivate func fetchAndCacheImage(_ url: URL, completion: @escaping (UIImage) -> Void) {
    if let data = try? Data(contentsOf: url),
       let image = UIImage(data: data, scale: UIScreen.main.scale) {
      completion(image)
      DispatchQueue.global(qos: .utility).async {
        let hash = "\(url.absoluteString.hash)"
        self.cachedImageNames.append(hash)
        let cacheImageURL = Constants.Directory.imageCache
          .appendingPathComponent(hash)
          .appendingPathExtension("jpg")
        try? data.write(to: cacheImageURL)
      }
    } else {
      completion(Asset.Images.placeholder.image)
    }
  }
  
  func image(_ url: URL, completion: @escaping (UIImage) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      let cachedImageName = "\(url.absoluteString.hash)"
      if self.cachedImageNames.contains(cachedImageName) {
        let cachedImageURL = Constants.Directory.imageCache
          .appendingPathComponent(cachedImageName)
          .appendingPathExtension("jpg")
        let data = try! Data(contentsOf: cachedImageURL)
        let image = UIImage(data: data, scale: UIScreen.main.scale)!
        completion(image)
      } else {
        self.fetchAndCacheImage(url, completion: completion)
      }
    }
  }
}
