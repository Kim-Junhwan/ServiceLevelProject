//
//  String+.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/25.
//

import Foundation

enum FormattingError: Error {
    case stringToDateFormatError
}

extension String {
    
    func phoneFormat() -> Self {
        var stringWithHypen: String = self
          if self.count >= 10 {
              stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
              stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
          } else if self.count >= 7 {
              stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
              stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 7))
          } else if self.count >= 4 {
              stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
          }
        return stringWithHypen
    }
    
    func toDate() throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: self) else { throw FormattingError.stringToDateFormatError }
        return date
    }
}
