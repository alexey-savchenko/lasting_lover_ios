//
//  DiscoverStoryCellViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import RxSwift
import UIKit

class DiscoverStoryCellViewModel: RoundedRectAndTitleSubtitleCellViewModelProtocol {
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
		return false
	}
	
	var accessoryViewMode: CardCell.AccessoryViewMode {
		return showNewTopicAccessory ? CardCell.AccessoryViewMode.show(title: L10n.discoverNewTopic) : .hide
	}
	
	var shouldDisplayCherryView: Bool {
		return true
	}
	
	init(story: Story, showNewTopicAccessory: Bool) {
		self.story = story
		self.showNewTopicAccessory = showNewTopicAccessory
	}
	
	let showNewTopicAccessory: Bool
	let story: Story
}
