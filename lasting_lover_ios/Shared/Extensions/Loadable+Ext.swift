//
//  Loadable+Ext.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import Foundation
import UNILibCore

extension Loadable {
	var item: T? {
		if case .item(let value) = self {
			return value
		} else {
			return nil
		}
	}
}
