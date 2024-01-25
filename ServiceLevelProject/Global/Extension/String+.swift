//
//  String+.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/25.
//

import Foundation

extension String {
  // MARK: - 휴대폰 번호 하이픈 추가
  public var withHypen: String {
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
}
