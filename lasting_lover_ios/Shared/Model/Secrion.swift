//
//  Secrion.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.11.2021.
//

import Foundation
import RxDataSources

struct Section<SectionItem>: SectionModelType {
	var items: [SectionItem]

	init(original: Section, items: [SectionItem]) {
		self = original
		self.items = items
	}

	init(items: [SectionItem]) {
		self.items = items
	}
}

extension Section: Hashable where SectionItem: Hashable {}

extension Section: Equatable where SectionItem: Equatable {}
