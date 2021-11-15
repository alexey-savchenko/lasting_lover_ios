//
//  Models.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 31.10.2021.
//

import Foundation

struct BackendResponse<T: Codable>: Codable {
	let status: BackendResponseStatus
	let data: [T]
}

enum BackendResponseStatus: String, Codable {
	case success
}

struct Author: Codable, Hashable {
	let id: Int
	let name: String
	let avatar: String
	let authorDescription: String
	let age: Int
	let type: Int?
	
	enum CodingKeys: String, CodingKey {
		case id, name, avatar
		case authorDescription = "description"
		case age, type
	}
}

struct Category: Codable, Hashable {
	let id: Int
	let name: String
	let avatar: String
	let categoryDescription: String
	let type, sort, featured: Int
	
	enum CodingKeys: String, CodingKey {
		case id, name, avatar
		case categoryDescription = "description"
		case type, sort, featured
	}
}

struct Series: Codable, Hashable {
	let id: Int
	let name: String
	let avatar: String
	let description: String
	let sort, featured: Int
	let categories: [Category]
	let authors: [Author]
	let type: Int
}

struct DiscoverData: Hashable {
	let authors: [Author]
	let categories: [Category]
	let series: [Series]
	let featuredStories: [Story]
}

enum StoryType: Int {
	case discover = 1
	case sleep = 2
}

struct Story: Codable, Hashable {
	let id: Int
	let name, storyDescription: String
	let audioURL: String
	let audioImg: String
	let paid, type, featured: Int
	let author: Author
	let series: SeriesTruncated
	let categories: [Category]
	let audioDuration: Int
	
	enum CodingKeys: String, CodingKey {
		case audioDuration = "audio_duration"
		case id, name
		case storyDescription = "description"
		case audioURL = "audio_url"
		case audioImg = "audio_img"
		case paid, type, featured, author, series, categories
	}
}

extension Story {	
	var title: String {
		return name
	}
	
	var authorName: String {
		return author.name
	}
	
	var artworkURL: URL {
		return URL(string: audioImg)!
	}
	
	var contentURL: URL {
		return URL(string: audioURL)!
	}
}

struct SeriesTruncated: Codable, Hashable {
	let id: Int?
	let name: String?
	let image: String?
	
	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case image
	}
	
	init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try? c.decode(Int.self, forKey: .id)
		self.name = try? c.decode(String.self, forKey: .name)
		self.image = try? c.decode(String.self, forKey: .image)
	}
	
	var isEmpty: Bool {
		return id == nil && name == nil && image == nil
	}
}

/// sourcery: lens
struct SleepData: Hashable {
	let categories: [Category]
	let featuredStories: [Story]
}
