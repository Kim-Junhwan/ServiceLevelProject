//
//  DateFormatter+.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/07.
//

import Foundation

extension DateFormatter {
    static let yearMonthDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yy. MM. dd"
        return df
    }()
    
    static let hourMinuteDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "hh:mm a"
        return df
    }()
    
    static let dayHourMinuteDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "MM/dd hh:mm a"
        return df
    }()
    
    static func todatStandardFormatting(_ date: Date) -> String {
        let today = Date()
        if Calendar.current.isDate(date, inSameDayAs: today) {
            return DateFormatter.hourMinuteDateFormatter.string(from: date)
        } else {
            return DateFormatter.dayHourMinuteDateFormatter.string(from: date)
        }
    }
}
