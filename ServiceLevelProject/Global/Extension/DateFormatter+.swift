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
}
