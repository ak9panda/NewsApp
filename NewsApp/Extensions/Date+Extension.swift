//
//  DateFormatter+Extension.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation

extension Date {
    
    init(dateString:String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
        return formatter
    }()
    
    static let dateOnly: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "EEEE, MMM d, yyyy"
         return formatter
    }()

    static func string(iso string: String) -> String {
        if string == "" {
            return ""
        }
        let date = Date(dateString: string)
        return Date.dateOnly.string(from: date)
    }
}
