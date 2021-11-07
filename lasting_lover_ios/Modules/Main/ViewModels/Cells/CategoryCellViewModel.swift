//
//  CategoryCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation

protocol CategoryCellViewModelProtocol {
	var title: String { get }
}

class CategoryCellViewModel: CategoryCellViewModelProtocol {
	
	init(category: Category) {
		self.category = category
	}
	
	var title: String {
		return category.name
	}
	
	let category: Category
}
