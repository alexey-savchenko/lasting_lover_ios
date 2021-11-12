//
//  AuthorStoryCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 12.11.2021.
//

import Foundation
import RxSwift
import UIKit

class AuthorStoryCellViewModel: RoundedRectAndTitleSubtitleCellViewModelProtocol {
	var image: Observable<UIImage> {
		return Current.imageLoadingService().image(URL(string: story.audioImg)!)
	}
	
	var title: String {
		return story.name
	}
	
	var subtitle: String {
		return story.storyDescription
	}
	
	var shouldDisplayPlayImage: Bool {
		return true
	}
	
	var accessoryViewMode: CardCell.AccessoryViewMode {
		return .hide
	}
	
	var shouldDisplayCherryView: Bool {
		return false
	}
	
	init(story: Story) {
		self.story = story
	}
	
	let story: Story
}
