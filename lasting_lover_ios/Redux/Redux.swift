//
//  State.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.09.2021.
//

import Foundation

struct AppState: Hashable {
	let profileState: ProfileState
}

struct ProfileState: Hashable {
	let subscriptionActive: Bool
}
