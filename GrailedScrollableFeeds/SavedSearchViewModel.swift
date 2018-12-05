//
//  SavedSearchViewModel.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation
import Moya

class SavedSearchViewModel {
    var id: Int?
    var name: String?
    var imageURL: String?
    var published: String?
    
    var searchService = MoyaProvider<SavedSearchService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    convenience init(search: SavedSearch) {
        self.init()
        self.id = search.id
        self.name = search.name
        self.imageURL = search.imageURL
        self.published = search.publishedAt
    }
    
    func captureSavedSearches(completion: @escaping ([SavedSearchViewModel]) -> ()) {
        searchService.request(.fetchSearches()) { (result) in
            switch result {
            case .success(let response):
                guard let searchdata = try? JSONDecoder().decode(SearchData.self, from: response.data) else {
                    print("Search data not decoded correctly")
                    return
                }
                
                let searches = searchdata.data.map { SavedSearchViewModel(search: $0) }
                completion(searches)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func imageSizeResolverUrl(size: Int) -> String {
        guard let hero = imageURL else { return "Hero not initiated"}
        let resizerURL = "https://cdn.fs.grailed.com/AJdAgnqCST4iPtnUxiGtTz/rotate=deg:exif/rotate=deg:0/resize=width:\(size),fit:crop/output=format:jpg,compress:true,quality:95/\(hero)"
        return resizerURL
    }
}
