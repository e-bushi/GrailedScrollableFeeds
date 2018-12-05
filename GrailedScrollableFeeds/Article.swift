//
//  Article.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation




struct ArticleData {
    var data: [Article]
    var metadata: Metadata
}

extension ArticleData: Codable {
    enum Keys: String, CodingKey {
        case data = "data"
        case metadata = "metadata"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.decode([Article].self, forKey: .data)
        
        let meta = try container.decode(Metadata.self, forKey: .metadata)
        
        self.init(data: data, metadata: meta)
    }
}

struct Article {
    var id: Int
    var url: String
    var title: String
    var publishedAt: String?
    var published: Bool
    var hero: String
    
}

extension Article: Codable {
    enum Keys: String, CodingKey {
        case id
        case url
        case title
        case publishedAt = "published_at"
        case published
        case hero
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        
        let url = try container.decode(String.self, forKey: .url)
        
        let title = try container.decode(String.self, forKey: .title)
        
        let publAt = try container.decode(String.self, forKey: .publishedAt).humanDate
        
        let pub = try container.decode(Bool.self, forKey: .published)
        
        let he = try container.decode(String.self, forKey: .hero)
        
        self.init(id: id, url: url, title: title, publishedAt: publAt, published: pub, hero: he)
    }
}

struct Metadata: Codable {
    var pagination: Pagination
}

struct Pagination: Codable {
    var next_page: String
    var current_page: String
    var previous_page: String
    
}
