//
//  SavedSearch.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation


struct SearchData: Codable {
    var data: [SavedSearch]
}

struct SavedSearch {
    var id: Int
    var name: String
    var imageURL: String
    var publishedAt: String
}

extension SavedSearch: Codable {
    enum Keys: String, CodingKey {
        case id
        case name
        case image = "image_url"
        case published = "published_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        
        let name = try container.decode(String.self, forKey: .name)
        
        let image = try container.decode(String.self, forKey: .image)
        
        let publish = try container.decode(String.self, forKey: .published).humanDate!
        
        self.init(id: id, name: name, imageURL: image, publishedAt: publish)
    }
}

