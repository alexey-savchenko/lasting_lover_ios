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
import UNILibCore

class AuthorViewControllerViewModel {
	struct Input {
		
	}
	
	struct Output {
		let title: String
		let subtitle: String
		let titleImage: Observable<UIImage>
		let content: Observable<Loadable<[Section<AuthorStoryCellViewModel>], HashableWrapper<AppError>>>
	}
	
	let input: Input
	let ouput: Output
	
	init(
		author: Author,
		state: Observable<DiscoverTab.State>,
		dispatch: @escaping DispatchFunction<DiscoverTab.Action>
	) {
		
		dispatch(.loadAuthorStories(value: author))
		
		self.input = Input()
		self.ouput = Output(
			title: "\(author.name), \(author.age)",
			subtitle: author.authorDescription,
			titleImage: Current.imageLoadingService().image(URL(string: author.avatar)!),
			content: state.compactMap { state in
				return state.authorStories[author]
			}
				.map { l in
					return l.map { array in return array.map(AuthorStoryCellViewModel.init) }
					.map(Section.init)
					.map(toArray)
				}
		)
		
		
	}
}
