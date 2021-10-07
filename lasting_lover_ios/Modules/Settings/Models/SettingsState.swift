//
//  SettingsState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import Foundation

/// sourcery: lens
struct SettingsState: Hashable, Codable {
  let subscriptionActive: Bool
}

enum SettingsAction {}
