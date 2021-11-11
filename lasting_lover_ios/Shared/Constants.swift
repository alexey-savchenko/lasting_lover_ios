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
  enum Backend {
    static let apiURL = URL(string: "https://cherrieapp.com/api/v1")!
    static let apiKEY = "0be3b027-6029-4102-84fa-7ba1c6cee3ac"
  }
	
	enum UserDefaults {
		static let purchasedPlanKey = "purchasedPlanKey"
		static let cachedAudioDurations = "cachedAudioDurations"
	}
}
