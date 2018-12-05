//
//  ArticleViewModel.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation
import Moya
import UIKit
import Kingfisher

class ArticleViewModel {
    var id: Int?
    var url: String?
    var title: String?
    var published_at: String?
    var published: Bool?
    var hero: String?
    var image = UIImageView()
    
    
    var articleService = MoyaProvider<ArticleService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    convenience init(article: Article) {
        self.init()
        self.id = article.id
        self.url = article.url
        self.title = article.title
        self.published_at = article.publishedAt
        self.published = article.published
        self.hero = article.hero
    }
    
    //fetch list of articles
    func captureArticles(completion: @escaping ([ArticleViewModel]) -> ()) {
        articleService.request(.fetchArticles()) { (result) in
            switch result {
            case .success(let response):
                guard let articledata = try? JSONDecoder().decode(ArticleData.self, from: response.data) else {
                    print("Articles weren't decoded correctly")
                    return
                }
                
                let articles = articledata.data.map { ArticleViewModel(article: $0) }
                completion(articles)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func imageSizeResolverUrl(size: Int) -> String {
        guard let hero = hero else { return "Hero not initiated"}
        let resizerURL = "https://cdn.fs.grailed.com/AJdAgnqCST4iPtnUxiGtTz/rotate=deg:exif/rotate=deg:0/resize=width:\(size),fit:crop/output=format:jpg,compress:true,quality:95/\(hero)"
        return resizerURL
    }
}

extension ArticleViewModel: Equatable {
    
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.url == rhs.url
    }
    
    
}
