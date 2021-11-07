//
//  SleepCategoryCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import RxSwift
import UIKit

class SleepCategoryCellViewModel: CircleImageAndTitleCellCellViewModel {
	init(category: Category) {
		self.category = category
	}
	
	var image: Observable<UIImage> {
		return Current.imageLoadingService().image(URL(string: category.avatar)!)
	}
	
	var title: String {
		return category.name
	}
	
	let category: Category
	
}
