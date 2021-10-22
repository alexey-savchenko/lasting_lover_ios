//
//  Constants.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 22.10.2021.
//

import Foundation

enum Constants {
  enum Directory {
    static let root = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let imageCache = Constants.Directory.root.appendingPathComponent("imageCache")
  }
}
