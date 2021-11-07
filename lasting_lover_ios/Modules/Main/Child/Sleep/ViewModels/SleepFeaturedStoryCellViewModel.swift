//
//  FeaturedStoryCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import RxSwift
import UIKit

class SleepFeaturedStoryCellViewModel: RoundedRectAndTitleSubtitleCellViewModelProtocol {
	var image: Observable<UIImage> {
		return Current.imageLoadingService().image(URL(string: story.audioImg)!)
	}
	
	var title: String {
		return story.name
	}
	
	var subtitle: String {
		return story.categories.map { $0.name }.joined(separator: ", ")
	}
	
	var shouldDisplayPlayImage: Bool {
		return true
	}
	
	var accessoryViewMode: CardCell.AccessoryViewMode {
		return .hide
	}
	
	var shouldDisplayCherryView: Bool {
		return true
	}
	
	init(story: Story) {
		self.story = story
	}
	
	let story: Story
}
