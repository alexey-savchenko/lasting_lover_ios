//
//  AuthorCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.11.2021.
//

import Foundation
import RxSwift
import UIKit

class AuthorCellViewModel: CircleImageAndTitleCellCellViewModel {
	var image: Observable<UIImage> {
		return Current
			.imageLoadingService()
			.image(URL(string: author.avatar)!)
	}
	
	var title: String {
		return author.name
	}
	
	init(author: Author) {
		self.author = author
	}
	
	let author: Author
}
