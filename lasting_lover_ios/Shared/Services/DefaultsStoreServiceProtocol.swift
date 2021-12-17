//
//  DefaultsStore.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import Foundation
import RxSwift

protocol DefaultsStoreServiceProtocol {
  func set(_ value: Any?, forKey defaultName: String)
  func setObject<T: Codable>(_ value: T?, forKey defaultName: String)
  func getObject<T: Codable>(forKey defaultName: String) -> T?
  func object(forKey defaultName: String) -> Any?

  func set(_ value: Bool, forKey defaultName: String)
  func bool(forKey defaultName: String) -> Bool

  func set(_ value: Int, forKey defaultName: String)
  func integer(forKey defaultName: String) -> Int

  func string(forKey defaultName: String) -> String?
  func dictionaryRepresentation() -> [String: Any]

	func observeReactive<E: Codable>(key defaultName: String) -> Observable<E?>
  func synchronize() -> Bool
}

extension UserDefaults: DefaultsStoreServiceProtocol {
  func setObject<T>(_ value: T?, forKey defaultName: String) where T: Decodable, T: Encodable {
		let string = value
			.flatMap { try? JSONEncoder().encode($0) }
			.flatMap { String.init(data: $0, encoding: .utf8) }
//    let data = String(data: try! JSONEncoder().encode(value), encoding: .utf8)!
    set(string, forKey: defaultName)
  }

  func getObject<T>(forKey defaultName: String) -> T? where T: Decodable, T: Encodable {
    string(forKey: defaultName)
      .flatMap { $0.data(using: .utf8) }
      .flatMap { data in
        try? JSONDecoder().decode(T.self, from: data)
      }
  }

  func observeReactive<E>(key defaultName: String) -> Observable<E?> where E: Decodable, E: Encodable {
		return UserDefaults.standard.rx
			.observe(String.self, defaultName)
			.map { str in
				return str
					.flatMap { unwrap in
						return unwrap.data(using: .utf8)
					}
					.flatMap { data in
						try? JSONDecoder().decode(E.self, from: data)
					}
			}
      .startWith(getObject(forKey: defaultName))
  }
}
