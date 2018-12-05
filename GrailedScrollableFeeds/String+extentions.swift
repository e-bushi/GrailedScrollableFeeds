//
//  String+extentions.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/5/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import Foundation

extension String {
    static var toDate: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'h:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
    
    static var toHumanReadableDate: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
    
    var date: Date? {
        return String.toDate.date(from: self)
    }
    
    var humanDate: String? {
        guard let dayMonthYear = date else { return "Nothing"}
        return String.toHumanReadableDate.string(from: dayMonthYear)
    }
}
