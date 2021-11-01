//
//  DiscoverState.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.10.2021.
//

import Foundation
import UNILibCore

enum Discover {
	
	/// sourcery: lens
	struct State: Hashable {
		let categories: [Category]
//		let 
	}
	
	/// sourcery: prism
	enum Action {
		
	}
	
	static let reducer = Reducer<Discover.State, Discover.Action> { state, action in
		return state
	}
	
}
