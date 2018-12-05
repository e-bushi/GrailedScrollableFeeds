//
//  SavedSearchService.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation
import Moya

enum SavedSearchService {
    case fetchSearches()
}

extension SavedSearchService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.grailed.com/api/merchandise/marquee")!
    }
    
    var path: String {
        return ""
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
