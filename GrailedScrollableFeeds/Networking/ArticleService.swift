//
//  ArticleService.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation
import Moya

enum ArticleService {
    case fetchArticles()
    case paginate()
}

extension ArticleService: TargetType {
    static var page: Int = 1
    
    var baseURL: URL {
        let resource = URL(string: "https://www.grailed.com/api/articles/ios_index?page=\(ArticleService.page)")!
        ArticleService.page += 1
        return resource
    }
    
    var path: String {
        return String()
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    
}
