//
//  AuthorViewControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 12.11.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UIKit

class AuthorViewControllerViewModel {
	struct Input {
		
	}
	
	struct Output {
		let title: String
		let subtitle: String
		let titleImage: Observable<UIImage>
	}
	
	let input: Input
	let ouput: Output
	
	init(
		author: Author,
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {
		self.input = Input()
		self.ouput = Output(
			title: "\(author.name), \(author.age)",
			subtitle: author.authorDescription,
			titleImage: Current.imageLoadingService().image(URL(string: author.avatar)!)
		)
		
		dispatch(.loadAuthorStories(value: author))
	}
}
