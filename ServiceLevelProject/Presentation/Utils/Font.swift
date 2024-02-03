//
//  Font.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/02.
//

import Foundation
import SwiftUI

enum CustomFont {
    case title1
    case title2
    case bodyBold
    case body
    case caption
    
    var font: Font {
        switch self {
        case .title1:
            return .system(size: 22, weight: .bold)
        case .title2:
            return .system(size: 14, weight: .bold)
        case .bodyBold:
            return .system(size: 13, weight: .bold)
        case .body:
            return .system(size: 13, weight: .regular)
        case .caption:
            return .system(size: 12, weight: .regular)
        }
    }
    
    var uifont: UIFont {
        switch self {
        case .title1:
            return .systemFont(ofSize: 22, weight: .bold)
        case .title2:
            return .systemFont(ofSize: 14, weight: .bold)
        case .bodyBold:
            return .systemFont(ofSize: 13, weight: .bold)
        case .body:
            return .systemFont(ofSize: 13, weight: .regular)
        case .caption:
            return .systemFont(ofSize: 12, weight: .regular)
        }
    }
}
